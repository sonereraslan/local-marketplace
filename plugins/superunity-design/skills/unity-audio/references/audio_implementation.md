# Audio Implementation — Unity Reference

## AudioMixer — Full Setup

### Mixer Hierarchy

```
Create: Assets -> Create -> Audio Mixer -> "MasterMixer"

Groups:
  Master
  +-- Music          -> expose "MusicVolume" parameter
  +-- SFX            -> expose "SFXVolume" parameter
  |   +-- Player     -> footsteps, actions, effort
  |   +-- World      -> interactions, environment objects, mechanisms
  |   +-- Combat     -> hits, projectiles, abilities, explosions
  |   +-- UI         -> menu sounds, notifications
  +-- Ambient        -> environment loops
  +-- Dialogue       -> voice, narration
```

### Exposed Parameters for Scripting

```csharp
// Get mixer reference
[SerializeField] AudioMixer masterMixer;

// Fade music volume (logarithmic conversion required)
public void SetMusicVolume(float normalised01)
{
    float db = Mathf.Log10(Mathf.Max(normalised01, 0.0001f)) * 20f;
    masterMixer.SetFloat("MusicVolume", db);
}

// Duck ambient under SFX (on interaction)
public void DuckAmbient(float targetVolume, float duration)
{
    StartCoroutine(FadeMixerGroup("AmbientVolume", targetVolume, duration));
}

IEnumerator FadeMixerGroup(string param, float targetDb, float duration)
{
    masterMixer.GetFloat(param, out float currentDb);
    float t = 0;
    while (t < 1)
    {
        t += Time.deltaTime / duration;
        masterMixer.SetFloat(param, Mathf.Lerp(currentDb, targetDb, t));
        yield return null;
    }
}
```

---

## Music Crossfade System

```csharp
public class MusicManager : MonoBehaviour
{
    [SerializeField] AudioSource sourceA;
    [SerializeField] AudioSource sourceB;
    [SerializeField] float crossfadeDuration = 1.5f;

    private AudioSource _active;
    private AudioSource _inactive;

    void Awake()
    {
        _active   = sourceA;
        _inactive = sourceB;
    }

    public void PlayMusic(AudioClip clip, float fadeTime = -1)
    {
        if (fadeTime < 0) fadeTime = crossfadeDuration;

        _inactive.clip   = clip;
        _inactive.volume = 0;
        _inactive.loop   = true;
        _inactive.Play();

        StartCoroutine(Crossfade(fadeTime));
    }

    public void StopMusic(float fadeTime = 1f)
    {
        StartCoroutine(FadeOut(_active, fadeTime));
    }

    IEnumerator Crossfade(float duration)
    {
        float t = 0;
        while (t < 1)
        {
            t += Time.deltaTime / duration;
            _active.volume   = Mathf.Lerp(1, 0, t);
            _inactive.volume = Mathf.Lerp(0, 1, t);
            yield return null;
        }
        _active.Stop();
        (_active, _inactive) = (_inactive, _active); // swap
    }

    IEnumerator FadeOut(AudioSource source, float duration)
    {
        float startVol = source.volume;
        float t = 0;
        while (t < 1)
        {
            t += Time.deltaTime / duration;
            source.volume = Mathf.Lerp(startVol, 0, t);
            yield return null;
        }
        source.Stop();
    }
}
```

---

## Ambient Ducking — On Interaction

```csharp
public class AmbientDucker : MonoBehaviour
{
    [SerializeField] AudioMixer mixer;
    [SerializeField] float duckVolume  = -10f; // dB
    [SerializeField] float fullVolume  =   0f;
    [SerializeField] float duckTime    = 0.1f;
    [SerializeField] float unduckTime  = 0.5f;

    public void Duck()   => StartCoroutine(FadeTo("AmbientVolume", duckVolume, duckTime));
    public void Unduck() => StartCoroutine(FadeTo("AmbientVolume", fullVolume, unduckTime));

    IEnumerator FadeTo(string param, float target, float duration)
    {
        mixer.GetFloat(param, out float current);
        float t = 0;
        while (t < 1)
        {
            t += Time.deltaTime / duration;
            mixer.SetFloat(param, Mathf.Lerp(current, target, t));
            yield return null;
        }
    }
}
```

---

## Audio Manager — Centralised Event Pattern

```csharp
// SoundId and MusicId enums — adapt to your game's needs
public enum SoundId
{
    // Player
    Footstep, Jump, Land, Dash, Dodge,
    // Actions
    Attack, HeavyAttack, Block, Parry,
    Interact, PickUp, Drop,
    // World
    DoorOpen, SwitchToggle, MechanismActivate,
    // Feedback
    Success, Fail, Damage, Heal,
    // UI
    MenuSelect, MenuBack, Notification
}

public enum MusicId
{
    MainTheme, ExplorationAmbient, CombatIntense,
    NarrativeSwell, TensionUnderscore, BossTheme,
    ResolutionTheme, VictoryStinger, DefeatStinger
}

// Audio manager — listens to events, plays sounds
public class AudioManager : MonoBehaviour
{
    [System.Serializable]
    public struct SoundEntry { public SoundId id; public AudioClip[] clips; }

    [System.Serializable]
    public struct MusicEntry { public MusicId id; public AudioClip clip; }

    [SerializeField] SoundEntry[] sounds;
    [SerializeField] MusicEntry[] music;
    [SerializeField] AudioSource sfxSource;
    [SerializeField] MusicManager musicManager;

    Dictionary<SoundId, AudioClip[]> _soundMap;
    Dictionary<MusicId, AudioClip>   _musicMap;

    void Awake()
    {
        _soundMap = new();
        foreach (var s in sounds) _soundMap[s.id] = s.clips;

        _musicMap = new();
        foreach (var m in music) _musicMap[m.id] = m.clip;

        AudioEvents.OnPlaySound  += PlaySound;
        AudioEvents.OnPlayMusic  += PlayMusic;
        AudioEvents.OnStopMusic  += StopMusic;
    }

    void OnDestroy()
    {
        AudioEvents.OnPlaySound  -= PlaySound;
        AudioEvents.OnPlayMusic  -= PlayMusic;
        AudioEvents.OnStopMusic  -= StopMusic;
    }

    void PlaySound(SoundId id)
    {
        if (!_soundMap.TryGetValue(id, out var clips) || clips.Length == 0) return;
        var clip = clips[Random.Range(0, clips.Length)];
        sfxSource.pitch = Random.Range(0.95f, 1.05f);
        sfxSource.PlayOneShot(clip);
    }

    void PlayMusic(MusicId id)
    {
        if (_musicMap.TryGetValue(id, out var clip))
            musicManager.PlayMusic(clip);
    }

    void StopMusic() => musicManager.StopMusic();
}
```

---

## Spatial Audio — Setup by Perspective

### 2D / 2.5D (side-scroll, top-down)

For 2D games, full 3D spatial audio is rarely needed. Use this hybrid approach:

```
Music:          2D — AudioSource.spatialBlend = 0
Ambient loops:  2D — spatialBlend = 0
Player SFX:     2D — spatialBlend = 0
World objects:  Light spatial — spatialBlend = 0.3-0.5
                (adds subtle stereo position without full 3D)
NPCs/Allies:    Light spatial — follows character X position
```

```csharp
// Soft stereo positioning for world objects (without full 3D audio)
public class StereoPositioner : MonoBehaviour
{
    [SerializeField] AudioSource audioSource;
    [SerializeField] Camera mainCamera;

    void Update()
    {
        // Normalise object position within camera view (-1 to 1)
        Vector3 viewPos = mainCamera.WorldToViewportPoint(transform.position);
        audioSource.panStereo = Mathf.Clamp((viewPos.x - 0.5f) * 2f, -0.8f, 0.8f);
    }
}
```

### 3D (third-person, first-person)

Use full 3D spatial audio for immersive positioning:

```
Music:          2D — spatialBlend = 0 (non-diegetic)
Diegetic music: 3D — spatialBlend = 1.0 (radios, instruments)
Ambient loops:  2D or light 3D — spatialBlend = 0-0.3
Player SFX:     2D — spatialBlend = 0
World objects:  3D — spatialBlend = 1.0
                Min Distance: 1-3m, Max Distance: 15-30m
Enemies:        3D — spatialBlend = 1.0 (directional threat)
Dialogue:       2D — spatialBlend = 0 (always clear)
```

```csharp
// Configure AudioSource for 3D spatial positioning
public static void Configure3DAudio(AudioSource source, float minDist = 2f, float maxDist = 20f)
{
    source.spatialBlend = 1f;
    source.minDistance = minDist;
    source.maxDistance = maxDist;
    source.rolloffMode = AudioRolloffMode.Logarithmic;
    source.spread = 60f; // stereo spread in degrees
}
```

---

## Ambient Loops — Seamless Setup

```csharp
public class AmbientLayer : MonoBehaviour
{
    [SerializeField] AudioSource source;
    [SerializeField] AudioClip   ambientClip;
    [SerializeField] float       fadeInDuration  = 2f;
    [SerializeField] float       fadeOutDuration = 1f;

    public void StartAmbient()
    {
        source.clip   = ambientClip;
        source.loop   = true;
        source.volume = 0;
        source.Play();
        StartCoroutine(FadeIn());
    }

    public void StopAmbient() => StartCoroutine(FadeOutAndStop());

    IEnumerator FadeIn()
    {
        float t = 0;
        while (t < 1)
        {
            t += Time.deltaTime / fadeInDuration;
            source.volume = Mathf.Lerp(0, 1, t);
            yield return null;
        }
    }

    IEnumerator FadeOutAndStop()
    {
        float startVol = source.volume;
        float t = 0;
        while (t < 1)
        {
            t += Time.deltaTime / fadeOutDuration;
            source.volume = Mathf.Lerp(startVol, 0, t);
            yield return null;
        }
        source.Stop();
    }
}
```

---

## Adaptive Music — Layer System

For games with dynamic music that responds to gameplay state:

```csharp
public class AdaptiveMusicManager : MonoBehaviour
{
    [SerializeField] AudioSource baseLayer;      // Always playing (ambient/calm)
    [SerializeField] AudioSource tensionLayer;   // Fades in during danger
    [SerializeField] AudioSource combatLayer;    // Fades in during combat
    [SerializeField] float fadeSpeed = 2f;

    private float _tensionTarget = 0f;
    private float _combatTarget  = 0f;

    public void SetState(MusicState state)
    {
        switch (state)
        {
            case MusicState.Calm:
                _tensionTarget = 0f; _combatTarget = 0f; break;
            case MusicState.Tension:
                _tensionTarget = 1f; _combatTarget = 0f; break;
            case MusicState.Combat:
                _tensionTarget = 1f; _combatTarget = 1f; break;
        }
    }

    void Update()
    {
        tensionLayer.volume = Mathf.MoveTowards(tensionLayer.volume, _tensionTarget, fadeSpeed * Time.deltaTime);
        combatLayer.volume  = Mathf.MoveTowards(combatLayer.volume, _combatTarget, fadeSpeed * Time.deltaTime);
    }
}

public enum MusicState { Calm, Tension, Combat }
```

---

## Audio Design Patterns by Genre

### Minimalist / Emotional (puzzle, narrative, platformer)
- Solo instruments or small ensembles
- Slow tempo, simple melodies
- Themes recur in different arrangements
- Silence before every major emotional beat
- Player sounds are soft — effort, not heroics

### Action / Combat (shooter, action, fighting)
- Layered adaptive music that responds to combat state
- Impactful hit sounds with weight and variation
- Spatial audio for threat awareness
- Musical stingers for kills, combos, critical events
- Audio intensity matches gameplay intensity

### Horror / Tension
- Minimal music — ambient drones and textures
- Absence of sound as a tool (silence = danger)
- Sudden audio spikes for scares (use sparingly)
- Environmental audio tells the story (creaks, distant sounds)
- Player heartbeat or breathing as tension indicator

### Open World / Exploration
- Continuous low-intensity underscore
- Region-specific ambient layers
- Music swells at points of interest
- Dynamic time-of-day audio (day vs. night ambience)
- Discovery stingers for finding new areas

### Design Lesson
The emotional moments are often the quiet ones. Reserve full instrumentation for the resolution, not the struggle. The impact of a sound is proportional to the silence that preceded it.
