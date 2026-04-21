# Unity Graph Toolkit (GTK) Architecture Patterns

Reference for building node-based visual tools with Unity Graph Toolkit (`com.unity.graphtoolkit@0.4`). GTK is an authoring-only framework — it provides the editor UI, and the developer implements runtime execution.

## Core Architecture

```
Editor Graph Asset (.ext)        ← authored in Editor
    ↓
ScriptedImporter (OnImportAsset) ← converts to runtime format
    ↓
Runtime Graph (ScriptableObject) ← lightweight data
    ↓
Director/Executor (MonoBehaviour)← executes at runtime
```

**Key separation:** Editor types define nodes, ports, and UI. Runtime types are pure data + execution. ScriptedImporter bridges the two.

## 1. Graph Class

Every GTK tool starts with a Graph subclass.

```csharp
[Graph(AssetExtension)]
[Serializable]
public class MyToolGraph : Graph
{
    public const string AssetExtension = "mytool";

    [MenuItem("Assets/Create/My Tool Graph")]
    public static void CreateAsset()
    {
        GraphDatabase.PromptInProjectBrowserToCreateNewAsset<MyToolGraph>();
    }

    // Validation on graph changes
    protected override void OnGraphChanged(GraphLogger logger)
    {
        // Example: require exactly one StartNode
        var startNodes = this.GetNodes<StartNode>();
        if (startNodes.Count() != 1)
            logger.LogError("Graph must have exactly one Start node.");
    }
}
```

## 2. Node Definition

Nodes define ports (inputs/outputs) and options (inspector properties).

```csharp
[Serializable]
internal class StateNode : Node
{
    // Define ports — fluent builder API
    protected override void OnDefinePorts(IPortDefinitionContext context)
    {
        // Execution port (flow control)
        context.AddInputPort(EXECUTION_PORT_DEFAULT_NAME)
            .WithDisplayName(string.Empty)
            .WithConnectorUI(PortConnectorUI.Arrowhead)
            .Build();

        // Typed data port
        context.AddInputPort<Texture2D>("textureInput")
            .WithDisplayName("Texture")
            .Build();

        // Multiple output ports
        for (int i = 0; i < transitionCount; i++)
        {
            context.AddOutputPort($"Transition{i}")
                .WithDisplayName($"Transition {i + 1}")
                .WithConnectorUI(PortConnectorUI.Arrowhead)
                .Build();
        }
    }

    // Define inspector options
    protected override void OnDefineOptions(INodeOptionDefinition context)
    {
        context.AddNodeOption(
            optionName: "stateName",
            dataType: typeof(string),
            optionDisplayName: "State Name",
            defaultValue: "New State"
        );
    }
}
```

**Port types:**
- Execution ports: flow control, no data (`PortConnectorUI.Arrowhead`)
- Data ports: typed values (`AddInputPort<T>`)
- Options: inspector-editable properties on the node

## 3. ScriptedImporter (Editor → Runtime Bridge)

Converts editor graph assets into runtime-friendly ScriptableObjects.

```csharp
[ScriptedImporter(version: 1, ext: MyToolGraph.AssetExtension)]
public class MyToolImporter : ScriptedImporter
{
    public override void OnImportAsset(AssetImportContext ctx)
    {
        // 1. Load editor graph
        var graph = GraphDatabase.Read<MyToolGraph>(ctx.assetPath);

        // 2. Create runtime graph (ScriptableObject)
        var runtimeGraph = ScriptableObject.CreateInstance<MyToolRuntimeGraph>();

        // 3. Traverse editor nodes → create runtime nodes
        // (Pattern varies: see Traversal Patterns below)

        // 4. Register as main asset
        ctx.AddObjectToAsset("runtime", runtimeGraph);
        ctx.SetMainObject(runtimeGraph);
    }
}
```

### Traversal Patterns

**Linear traversal** (Visual Novel pattern):
```csharp
INode current = FindStartNode(graph);
while (current != null)
{
    runtimeGraph.Nodes.Add(TranslateNode(current));
    current = GetNextNode(current); // follow execution port
}
```

**Two-pass traversal** (StateMachine pattern):
```csharp
// Pass 1: Create all runtime nodes, build index map
var nodeMap = new Dictionary<INode, int>();
foreach (var node in graph.GetNodes<StateMachineNode>())
{
    nodeMap[node] = runtimeGraph.Nodes.Count;
    runtimeGraph.Nodes.Add(CreateRuntimeNode(node));
}

// Pass 2: Resolve connections using index map
foreach (var (editorNode, index) in nodeMap)
{
    var runtimeNode = runtimeGraph.Nodes[index];
    foreach (var connected in GetConnectedNodes(editorNode))
        runtimeNode.NextNodeIndices.Add(nodeMap[connected]);
}
```

**Compile-to-output** (TextureMaker pattern):
```csharp
// No runtime graph — generate output asset directly
var resultNode = graph.GetNodes<CreateTextureNode>().First();
Texture2D texture = EvaluateNodeTree(resultNode);
ctx.AddObjectToAsset("texture", texture);
ctx.SetMainObject(texture);
```

## 4. Runtime Graph

Lightweight ScriptableObject holding serialized runtime nodes.

```csharp
public class MyToolRuntimeGraph : ScriptableObject
{
    [SerializeReference]
    public List<RuntimeNode> Nodes = new List<RuntimeNode>();
}

// Base runtime node — use [SerializeReference] for polymorphism
[Serializable]
public abstract class RuntimeNode
{
    public List<int> NextNodeIndices = new List<int>();
}

// Concrete runtime nodes — pure data, no logic
[Serializable]
public class StateRuntimeNode : RuntimeNode
{
    public string StateName;
}
```

**Key:** `[SerializeReference]` on the list enables polymorphic serialization of different node types.

## 5. Runtime Execution (Director + Executor)

### Synchronous Pattern (State Machine)

```csharp
public class MyToolDirector : MonoBehaviour
{
    [SerializeField] private MyToolRuntimeGraph runtimeGraph;

    private Dictionary<Type, object> executors = new();
    private RuntimeNode currentNode;

    void Awake()
    {
        // Register executors
        executors[typeof(StateRuntimeNode)] = new StateNodeExecutor();
        executors[typeof(TransitionRuntimeNode)] = new TransitionNodeExecutor();
        currentNode = runtimeGraph.Nodes[0];
    }

    void Update()
    {
        Execute(currentNode);
    }

    void Execute(RuntimeNode node)
    {
        // Type-switch to find executor
        switch (node)
        {
            case StateRuntimeNode stateNode:
                GetExecutor<StateRuntimeNode>().Execute(stateNode, this);
                break;
        }
    }

    T GetExecutor<T>() => (T)executors[typeof(T)];
}

// Executor interface — returns bool for branching decisions
public interface INodeExecutor<TNode> where TNode : RuntimeNode
{
    bool Execute(TNode node, MyToolDirector context);
}
```

### Asynchronous Pattern (Visual Novel)

```csharp
public class StoryDirector : MonoBehaviour
{
    [SerializeField] private StoryRuntimeGraph runtimeGraph;

    private async void Start()
    {
        foreach (var node in runtimeGraph.Nodes)
        {
            switch (node)
            {
                case DialogueRuntimeNode dialogue:
                    await new DialogueExecutor().ExecuteAsync(dialogue, this);
                    break;
                case WaitForInputRuntimeNode wait:
                    await new WaitForInputExecutor().ExecuteAsync(wait, this);
                    break;
            }
        }
    }
}

// Async executor interface
public interface INodeExecutorAsync<TNode>
{
    Task ExecuteAsync(TNode node, StoryDirector context);
}
```

## Choosing an Execution Pattern

| Pattern | Use When | Example |
|---------|----------|---------|
| **Synchronous (Update)** | State-based, conditional branching, continuous evaluation | State machines, AI behavior trees, ability systems |
| **Asynchronous (await)** | Linear sequences with waits, player interaction pauses | Dialogue systems, cutscenes, tutorials |
| **Compile-to-output** | No runtime execution, result generated at import | Texture generators, mesh generators, data bakers |

## Port Value Resolution

Consistent pattern for reading port values in importers:

```csharp
// 1. Check if port has a connection → read from connected node
// 2. Fall back to embedded value on the port
// 3. Fall back to default

var port = node.GetPort("inputName");
if (port.IsConnected)
{
    var connectedNode = port.GetConnectedNode();
    value = EvaluateNode(connectedNode);
}
else
{
    value = port.GetEmbeddedValue<T>();
}
```

## Assembly Definition Structure

```
MyTool/
├── Editor/
│   ├── MyTool.Editor.asmdef        ← references: GraphToolkit.Editor
│   ├── MyToolGraph.cs
│   ├── Nodes/
│   │   └── MyNode.cs
│   └── AssetImport/
│       └── MyToolImporter.cs
└── Runtime/
    ├── MyTool.Runtime.asmdef        ← no Editor references
    ├── MyToolRuntimeGraph.cs
    ├── MyToolDirector.cs
    └── Nodes/
        ├── RuntimeNode.cs
        └── MyRuntimeNode.cs
```

**Rule:** Runtime assembly must never reference Editor assembly. The ScriptedImporter bridges the gap at import time.
