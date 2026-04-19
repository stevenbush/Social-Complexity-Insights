# Figure Brief — Civitas-Twin Blog Post

This file catalogues every figure referenced from `blog-social-systems-05-building-a-social-digital-twin.md`. It exists so that all illustrations can be generated — by hand, by vector editor, or by an image model — with a *consistent* visual identity across the post.

---

## Shared Visual Style Preamble

*Every generation prompt below begins by applying this preamble. Do not override it with figure-specific overrides unless a figure genuinely requires it.*

- **Output format.** Flat 2D technical diagram. No 3D isometric unless the figure explicitly asks for it. Transparent or off-white background. Aspect ratio 16:9 unless specified otherwise.
- **Palette.** Cool neutral base (graphite `#1F2A37`, slate `#475569`, mist `#E2E8F0`, parchment `#F8FAFC`). Accent blue `#3B82F6` for data flow. Accent amber `#F59E0B` for LLM / cognitive paths. Muted red `#DC2626` used sparingly, reserved for hazard or failure-mode annotations. Soft green `#16A34A` used sparingly, reserved for provenance / verified paths.
- **Strokes.** Thin 1.5–2 px strokes. No drop shadows. No gradients. Arrowheads are small, simple, filled triangles.
- **Shapes.** Rectangles with 4–6 px rounded corners for services/modules; parallelograms for data stores; hexagons for LLM components; circles for humans or stakeholder actors. No icons from generic clip-art libraries.
- **Typography.** Single sans-serif family throughout (Inter, Source Sans, or similar). Block titles ~14 pt. Labels ~10 pt. No all-caps, no italics, no drop caps.
- **Composition.** Clear left-to-right or top-to-bottom flow. A figure has at most 7 primary blocks at the top level. Every arrow is labelled with one short verb or noun.
- **Tone.** Engineering schematic, not marketing deck. A reader should immediately believe the diagram was drawn by someone who has actually built the system. No emojis, no cartoon characters, no stock photography, no 3D renders of servers or brains.

When the figure is a *comparison plot* or *trade-off curve*, additional rules apply:

- Axes labelled with units. Legend in the lower-right. No grid-line clutter. Data series coloured from the accent palette above, one accent per series.

---

## Figure Catalogue

### Figure 1 — Opening schematic: the research stack, city-grounded
- **Used in.** §0 Title & Epigraph.
- **Caption.** *"A Social Digital Twin is not a monolith but a layered research stack — and the layer most at risk is trust."*
- **Surrounding context.** Opens the post immediately after the title. Signals continuity with the prior post (which introduced a trustworthy layered stack in the abstract) and grounds the stack in a city silhouette.
- **Generation prompt.** Apply the shared visual style preamble. A horizontal diagram in two halves. Left half: a stylised city silhouette in graphite, with faint silhouettes of roads, a harbour line, a transit spine, and small dots for residents (synthetic agents). Right half: a stack of six horizontal layers (Data, Physical, Cognitive, Bus, UI, Observability), labelled cleanly, with thin amber threads crossing from the city into the stack. Title across the top: "From City to Stack". No corporate branding.

### Figure 2 — Portfolio view of Civitas-Twin
- **Used in.** §1 Introduction.
- **Caption.** *"One synthetic population, one physical substrate, many scenario cartridges."*
- **Surrounding context.** Reframes the reader's mental model: a digital twin is not a single-scenario emergency tool but a shared platform that carries multiple cartridges.
- **Generation prompt.** Apply the shared visual style preamble. Centre: two stacked slab rectangles labelled "Synthetic Population" and "Physical Substrate" in graphite. Radiating outward on five sides: five rectangular cartridges labelled "Everyday Dynamics", "Policy What-Ifs", "Societal Stressors", "Preparedness Drills", "Long-Horizon Planning", each in parchment with a thin slate border. Thin blue arrows from the central slabs into each cartridge. One thin amber arrow from the central stack upward to a small hexagon labelled "LLM Cognition" at the top, indicating cartridge-agnostic reuse.

### Figure 3 — ABM platform positioning map
- **Used in.** §2 Industry status.
- **Caption.** *"A platform lives at a point in two coordinates it cannot optimise simultaneously."*
- **Surrounding context.** Supports the comparison table — no platform wins; each occupies a position.
- **Generation prompt.** Apply the shared visual style preamble. A 2D scatter plot. X-axis labelled "Spatial / physical fidelity" from "symbolic grid" (left) to "GIS-accurate continuous space" (right). Y-axis labelled "Cognitive / linguistic depth" from "rule-based FSM" (bottom) to "LLM-native" (top). Bubbles placed as follows: NetLogo (lower-left, small), Mesa (centre-left, medium), Repast (lower-centre, large), GAMA (lower-right, medium), MASON (lower-centre, small), AgentTorch (centre, small, in amber), FLAME GPU (centre-right, medium), CAMEL (upper-left, medium, amber), MaDKit (centre-left, small). Bubble area encodes community maturity.

### Figure 4 — Requirements-to-commitments traceability
- **Used in.** §3 Scenario & requirements.
- **Caption.** *"Every downstream design decision must trace back to one of six architectural commitments."*
- **Surrounding context.** Ties the cartridge portfolio and the functional/non-functional/constraint matrix to six explicit commitments used throughout §4.
- **Generation prompt.** Apply the shared visual style preamble. Three vertical columns with light dividers. Left column: five cartridge names stacked as small slate rectangles. Middle column: six numbered commitment boxes (1. Brain–Body Separation, 2. Privacy-by-Synthesis, 3. Lazy Cognition, 4. Event-Driven Orchestration, 5. Single Source of Truth, 6. Human-in-the-Loop Observability) in parchment with amber accent numbers. Right column: six slate rectangles for downstream architecture layers (Data, Physical, Cognitive, Bus, UI, Observability). Thin blue arrows from left to middle, then from middle to right, showing the many-to-many trace. Each commitment connects to multiple layers.

### Figure 5 — Master architecture overview
- **Used in.** §4 opener.
- **Caption.** *"Six horizontal layers, one vertical observability spine."*
- **Surrounding context.** The canonical diagram the entire §4 refers back to.
- **Generation prompt.** Apply the shared visual style preamble. A tall rectangular frame divided into six horizontal layers from bottom to top: Data Middle Platform, Physical Substrate, Cognitive & Socio-Emotional Hub, Communication Bus, Visualization & Decision Support, Human-in-the-Loop. Running vertically on the right edge, spanning all six layers, a narrow amber band labelled "Observability & Provenance Spine" with small tap-icons at each layer. Inside each horizontal layer, 3–5 small labelled rectangles for core services (e.g., Data: PostGIS, Geoserver, Milvus, Redis, Neo4j, DuckDB; Physical: GAMA Headless, R-Tree, Domain Decomp; Cognitive: asyncio, LlamaIndex Workflows, NetworkX, vLLM adapter; Bus: gRPC, Kafka, Arrow, Protobuf; UI: React, Unity WebGL, D3.js, Django, Flask; Human-in-the-Loop: Analyst Interview, Provenance Browser). No decoration.

### Figure 6 — Data synthesis pipeline
- **Used in.** §4.2 Data layer.
- **Caption.** *"From microdata to agents: a four-stage, privacy-first pipeline."*
- **Surrounding context.** Explains the WGAN → household aggregation → IPF calibration → spatial allocation chain and where each output lands (PostGIS, downstream consumers).
- **Generation prompt.** Apply the shared visual style preamble. A left-to-right flow with five stations as slate rectangles: "Microdata (synthetic or public-statistics-class)" → "WGAN Generator + Wasserstein Critic" (hexagonal, amber) → "Household Aggregation (demographic keys)" → "IPF Calibration (marginal matching)" → "Spatial Allocation (within building footprints)". Two output parallelograms at the right: "PostGIS / Geoserver" and "Neo4j social graph". A small green provenance lozenge attached underneath the pipeline labelled "Every row carries lineage". A muted red dashed annotation on the first station reading "never identifies real individuals".

### Figure 7 — Physical engine internals
- **Used in.** §4.3 Physical-space computing base.
- **Caption.** *"Where the physics lives: true multithreading, spatial indexing, headless gRPC, partition-ready."*
- **Surrounding context.** Makes the JVM/C++ engine concrete; foreshadows Phase 3 spatial partitioning.
- **Generation prompt.** Apply the shared visual style preamble. A rectangular frame labelled "Physical Substrate Service (headless)". Inside: a central square labelled "Agent World (species, geometry, fields)"; wrapped by an R-Tree icon (a small nested rectangle tree) to its left; four CPU-core icons below labelled "Worker Threads"; a small gRPC endpoint rectangle on the right edge labelled "Intent In / State Out". Dashed amber vertical lines cut the Agent World into four panels, each panel labelled "Partition 1..4", with a small comment in the margin reading "Domain decomposition — Phase 3 hook".

### Figure 8 — Cognitive-hub state machine
- **Used in.** §4.4 Cognitive & socio-emotional hub.
- **Caption.** *"A cognitive agent is dormant by default; it earns an LLM call."*
- **Surrounding context.** Anchors the lazy-evaluation and System 1 / System 2 discussion.
- **Generation prompt.** Apply the shared visual style preamble. A state diagram with five rounded states arranged in a horizontal timeline: "Dormant" → "Perceive" → "System 1 (fast reflex)" → "System 2 (deliberation)" → "Publish Intent". Dormant and Perceive in slate; System 1 in parchment with a blue accent; System 2 in parchment with an amber accent and a small hexagonal LLM icon inside. Arrows labelled with trigger names ("threshold crossed", "cache hit", "cache miss", "intent ready"). A small green lozenge attached beneath Publish Intent reading "write-back with provenance tag". Looping arrow back to Dormant labelled "go back to sleep".

### Figure 9 — Communication-bus topology
- **Used in.** §4.5 Communication bus & interaction fabric.
- **Caption.** *"Three interaction patterns, one wire format."*
- **Surrounding context.** Shows gRPC / Kafka / Redis / Arrow side by side and marks the intent double-buffer.
- **Generation prompt.** Apply the shared visual style preamble. A central horizontal bar labelled "Protobuf / Apache Arrow wire format" running the full width. Above the bar: five service rectangles in a row (Physical Substrate, Cognitive Hub, Data Middle Platform, Visualization, Analyst Console). Below the bar: three bus channels as elongated lozenges labelled "gRPC — Command / RPC", "Kafka — Event / Replay", "Redis — State Blackboard". Each service has thin blue arrows to/from each channel. On the right edge, a small amber sub-cluster labelled "Intent Double-Buffer" with two stacked slots (read-only, writable), and a tiny green tap labelled "Provenance tap" leading off to an Observability side-box.

### Figure 10 — Visualization UI anatomy
- **Used in.** §4.6 Visualization & decision-support layer.
- **Caption.** *"Container-Satellite UI: a thin shell, heavy tenants, and a protected prompt."*
- **Surrounding context.** Explains the React shell, Unity WebGL viewport, D3.js windows, SSE streaming LLM dialogue, dual-track backend, and why System Prompts are never edited directly.
- **Generation prompt.** Apply the shared visual style preamble. A large rounded rectangle labelled "React Container" filling most of the canvas. Inside: a dominant Unity-WebGL viewport (centre-left), three floating satellite windows — "Heatmap (D3.js)", "Funnel S-curve (D3.js)", "Analyst Interview (SSE stream)" — in parchment with slate borders. Arrows on the bottom edge going out to two backend rectangles: "Django (ORM, policy, audit)" and "Flask/FastAPI (hot path + LLM gateway)". A small amber hexagon labelled "vLLM" connected to Flask. An annotation arrow at the UI pointing to a little lock icon on the system-prompt input labelled "Personality Sliders — never raw prompt".

### Figure 11 — Memory-stream network
- **Used in.** §4.7 LLM integration & orchestration.
- **Caption.** *"Per-agent memory is a stream; the social graph turns it into a network."*
- **Surrounding context.** Generalises Park et al. memory streams into a network spanning the social graph, with reflection arcs and provenance stamps.
- **Generation prompt.** Apply the shared visual style preamble. Three vertical columns. Left column: two stacked small rectangles labelled "Agent A stream" and "Agent B stream"; each rectangle is a scrollable column of tiny event chips (each chip is a thin parchment rounded rectangle with a time-stamp). Middle column: a network graph (small circles connected by thin lines, annotated "Social Graph — NetworkX"). Right column: a parallelogram labelled "Shared Group Stream (neighbourhood, workplace)". Curved amber arcs connect individual chips across streams to a small hexagon labelled "Reflection". A green lozenge at the bottom reads "Every entry stamped with (time, source, confidence)". Underneath everything: a thin horizontal slab labelled "Vector DB (Milvus)".

### Figure 12 — LlamaIndex Workflow spine, two cartridges
- **Used in.** §4.7 LLM integration & orchestration.
- **Caption.** *"The same workflow spine answers a preparedness question and a policy question."*
- **Surrounding context.** Makes the cartridge-agnostic reuse concrete by showing the same DAG spine annotated with two different sets of event types.
- **Generation prompt.** Apply the shared visual style preamble. A single horizontal DAG across the centre, with five nodes as rounded rectangles: "Event In" → "Retrieval" → "Reflection" → "Plan" → "Emit Intent". Two thin parallel tracks labelled above and below the DAG. Upper track in muted red: "HazardPerceived → evacuation plan → IntentNavigateTo (exit_node)". Lower track in blue: "NewRouteAnnounced → mode-choice deliberation → IntentTravelMode (transit)". An amber hexagon hovering over the "Reflection" node labelled "LLM call, cache-aware, batched". A small green provenance tap under "Emit Intent".

### Figure 13 — AGR in action across two cartridges
- **Used in.** §4.8 AGR organizational mechanism.
- **Caption.** *"One resident, two cartridges, two role flips — same machinery."*
- **Surrounding context.** Shows how Agent / Group / Role supports both policy cartridges and preparedness cartridges with identical plumbing.
- **Generation prompt.** Apply the shared visual style preamble. A human-shaped circle labelled "Resident #12048" in the centre. Two orbits around it. Upper orbit: "Commuter" role → "Transit-Advocate" role (role change arrow in blue, trigger "NewRouteAnnounced"). Lower orbit: "Resident" role → "Evacuee" role (role change arrow in muted red, trigger "HazardPerceived"). On the left, a parallelogram labelled "Group: Neighbourhood #7 (spatial, R-Tree)". On the right, a parallelogram labelled "Group: Household #512 (social, NetworkX)". Two thin arrows from each role box out to the groups indicating the scope of communication. A small amber hexagon off to the side labelled "LLM workflow template" with two dashed lines pointing at each role flip, emphasising template reuse.

### Figure 14 — Node topology at Phase 2, with evolution arrows
- **Used in.** §5 Hardware architecture.
- **Caption.** *"Three fat nodes, one workstation, a 100 GbE direct-connect — and clear arrows to Phases 3 and 4."*
- **Surrounding context.** Concrete hardware diagram for the minimal cluster and how it grows.
- **Generation prompt.** Apply the shared visual style preamble. Four rectangles arranged in a triangle with a small rectangle off to the side. Top-centre: "PS-Node — Physical Substrate (EPYC 9654 dual, 512 GB DDR5, no GPU, 2×100 GbE)". Lower-left: "AI-Node — LLM Inference (32 cores, 512 GB, 4×H100 80 GB, 400 GbE IB)". Lower-right: "SB-Node — Middleware (Redis, Kafka, Milvus; NVMe RAID-10; 2×100 GbE)". Bottom-right corner: "UI-Workstation (i9-14900K, RTX 4090, 25 GbE uplink)". A labelled cloud in the top-right: "Offsite replay / backup". Connecting lines labelled with link rates. Below the cluster, two ghost groups drawn in light dashed lines and labelled "Phase 3 (spatial partitioning, 2–3 PS-Nodes, spine-leaf 100 GbE)" and "Phase 4 (K8s bare-metal, RoCE, AgentTorch)", with short arrows pointing forward from Phase 2.

### Figure 15 — Cost-fidelity frontier
- **Used in.** §6 Challenges & optimization.
- **Caption.** *"Every optimisation trades cost for fidelity — the question is where on the frontier you choose to stand."*
- **Surrounding context.** Visualises the four LLM-call regimes (individual, archetype, semantic cache, System 1 heuristic) as a continuous trade-off curve.
- **Generation prompt.** Apply the shared visual style preamble. A 2D trade-off plot. X-axis: "Compute cost per scenario tick" (log scale, left → right: low to high). Y-axis: "Behavioural fidelity" (left → right: low to high). A single curve rising monotonically from lower-left to upper-right, labelled "Frontier". Four dots on the curve labelled left-to-right: "System-1 heuristic", "Semantic cache", "Archetype sampling", "Individual LLM inference". A dashed horizontal line labelled "Minimum fidelity threshold for civic trust" crossing the curve near the third dot. A small amber arrow pointing to that crossing and labelled "The design sweet spot".

### Figure 16 — Closing synthesis
- **Used in.** §8 Summary.
- **Caption.** *"Closing synthesis: the six-layer stack, the trust spine, and the four future research directions extending outward from it."*
- **Surrounding context.** Final synthesis image that links the reference architecture to open research questions.
- **Generation prompt.** Use the shared Civitas-Twin visual style: cool neutral palette, flat vector synthesis diagram, thin strokes, restrained highlights. Re-show the six-layer architecture with the trust spine emphasized, then extend four labeled research-direction paths outward: interpretability, local inference infrastructure, NetLogo translation for interpretability, and hybrid human-AI society simulation. It should feel conclusive but still open-ended."

---

## Usage notes

- **File naming convention.** `fig-01-opening.png`, `fig-02-portfolio.png`, … `fig-16-closing.png`. PNG at ≥ 1600 × 900 px for the body figures; scale down via markdown rendering.
- **One figure per prompt.** Do not ask a model to render two figures in one call, even when they appear consecutively — consistency suffers.
- **After generation, cross-check.** Every figure's colour palette and typography should match the shared preamble. Reject outputs that introduce new colours, stock iconography, emoji, or 3D renders.
