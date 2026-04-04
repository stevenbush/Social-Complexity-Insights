# Building an Interface for Simulated Societies

*How a white-box agent-based model, a multi-page Dash application, and a carefully bounded LLM layer became one attempt at a research-facing interface rather than just another dashboard.*

## Opening Hook

For a while, my workflow for this project looked like a familiar research loop: edit a parameter in code, launch a batch run, wait for the results, open a static figure, and try to reconstruct what had just happened. That workflow was productive, but it had a hard ceiling. It could tell me what the model produced. It was much worse at helping me inspect why a pattern emerged, what assumptions shaped it, and how I could explain the result to someone who had not lived inside the codebase.

That gap matters more than it sounds. Agent-based modeling is not only about computation. It is also about making mechanism legible. In an earlier essay, [*Simulating Society in the Age of AI*](https://stevenbush.github.io/Social-Complexity-Insights/2026/03/31/simulating-society-age-of-ai/), I described this as a version of "making the invisible visible": not just plotting outcomes, but exposing how rules, parameters, and interpretation pathways fit together. Once I started treating the interface itself as part of the research instrument, the dashboard stopped being a presentation layer and became part of the methodology.

That shift shaped the design of [*The Convenience Paradox*, my small personal test project on GitHub](https://github.com/stevenbush/convenience-paradox). Rather than treating the interface as a finished product, I approached it as a useful prototype: an attempt to build a research-facing layer on top of the simulation for configuring experiments, running them interactively, comparing runs, annotating results, and interrogating the model with LLM assistance without giving up the white-box logic of the ABM core. What emerged is a four-page Dash application that, while still exploratory in spirit, points toward one idea I want to keep developing: a good interface should not hide complexity. It should help researchers navigate it, and it can serve as a foundation for further iterations.

## Architecture: The Interface as Research Infrastructure

This interface is a small multi-page Plotly Dash prototype with four pages: **Simulation Dashboard**, **LLM Studio**, **Run Manager**, and **Analysis**. The design is easiest to understand as two layers.

The first is the **visible application layer**: Dash provides the shell, navigation, and interaction model; Plotly provides the charts; SQLite preserves runs for later comparison. This is the part the user touches directly.

The second is the **shared control layer** behind it: server-side state keeps the current simulation alive, small browser stores coordinate page interactions, and Python callbacks connect the interface directly to the Mesa model and the LLM service. That keeps the whole system in one coherent workflow instead of splitting it into disconnected tools.

The architecture diagram below shows that structure in concrete terms: interface on top, control and state in the middle, and simulation, LLM, and persistence services underneath.

<figure style="margin:1.75rem auto 1.4rem auto; width:100%; max-width:1040px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/architecture-overview.svg" alt="Architecture overview of The Convenience Paradox interface, showing the Dash presentation layer, Python callback control plane, and the ABM, LLM, and data services underneath." width="1040" loading="lazy" style="display:block; width:100%; max-width:1040px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Figure — Architecture overview of the current interface prototype.</strong> It shows how the Dash pages, the control/state layer, the Mesa simulation, the LLM service, and SQLite persistence fit together.</figcaption></figure>

The concrete diagram maps directly onto the implementation. The abstract sketch below complements it by showing the same system at the level of design logic: model at the core, interface around it, and provenance connecting the layers.

<figure style="margin:1.85rem auto 1.7rem auto; width:100%; max-width:960px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/Illustration-1.png" alt="Sketchnote-style layered research interface stack showing the Mesa ABM engine, server-side state, Dash pages, schema and audit layer, and LLM Studio connected by a provenance column." width="960" loading="lazy" style="display:block; width:100%; max-width:960px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Illustration 1 — The Research Interface Stack.</strong> A layered view of the interface: simulation engine at the core, Dash shell above it, and schemas plus audit linking the LLM layer to the rest of the system.</figcaption></figure>

What makes the architecture distinctive is **LLM Studio**. Instead of adding one generic chatbot, the interface separates five roles: scenario design, profile generation, result interpretation, chart annotation, and bounded forum experiments. This makes the LLM layer feel less like a gimmick and more like a set of research tools with different jobs.

Just as importantly, those roles do not all sit in the same place. Most stay at the model's edges: they help configure, explain, or annotate. Only the forum mode enters the simulation loop, and even there the interface makes the boundary explicit through experimental labeling, short exchanges, capped updates, and auditability. That is the core architectural idea: the LLM is used as an interface layer around a transparent model, not as a hidden substitute for it.

## Feature Showcase: A Quick Tour of the Interface

Before diving into the LLM layer, it helps to see the rest of the workbench in motion.

### Simulation Dashboard

The landing page is the operational center of the simulation. It combines parameter controls, preset switching, run actions, KPI cards, and a broad set of Plotly views: labor hours, stress and delegation, market health, provider-consumer stratification, task flows, and network topology. The goal is not just to show a few pretty charts. It is to let a researcher adjust assumptions and immediately see how the system responds.

<figure style="margin:1.75rem auto 1.4rem auto; width:100%; max-width:1040px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/simulation-dashboard.gif" alt="Animated walkthrough of the Simulation Dashboard showing parameter controls, live KPI cards, and multiple synchronized charts updating during a run." width="1040" loading="lazy" style="display:block; width:100%; max-width:1040px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Simulation Dashboard.</strong> The Simulation Dashboard in action: parameter controls on the left, live KPIs on top, and multiple synchronized visual views updating as the run advances.</figcaption></figure>

### Run Manager

Once runs accumulate, the question shifts from "what is happening now?" to "how do these experiments compare?" The Run Manager answers that with a SQLite-backed history table, filtering controls, editable labels, and one-metric comparison overlays. It turns simulation output into something closer to a lightweight experiment database.

<figure style="margin:1.75rem auto 1.4rem auto; width:100%; max-width:1040px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/run-manager.gif" alt="Animated walkthrough of the Run Manager showing saved simulation history, filtering controls, editable labels, and metric comparison overlays." width="1040" loading="lazy" style="display:block; width:100%; max-width:1040px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Run Manager.</strong> Run history, filtering, and metric comparison in the Run Manager, turning saved simulations into something inspectable rather than disposable.</figcaption></figure>

### Analysis

The Analysis page packages results for communication. It combines hypothesis cards, a preset-to-preset comparison workflow, and an interactive sensitivity heatmap. This is where the interface shifts from "running a model" to "presenting findings from a model" without leaving the application.

<figure style="margin:1.75rem auto 1.4rem auto; width:100%; max-width:1040px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/analysis.gif" alt="Animated walkthrough of the Analysis page showing hypothesis cards, preset comparison views, and an interactive sensitivity heatmap." width="1040" loading="lazy" style="display:block; width:100%; max-width:1040px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Analysis.</strong> The Analysis page presents research-facing views: hypothesis status, preset comparison, and an on-demand sensitivity heatmap.</figcaption></figure>

### LLM Studio, Briefly

One page, however, changes the character of the whole system. **LLM Studio** is where the interface stops being only a dashboard and becomes a research assistant layer. It brings together scenario parsing, profile generation, result interpretation, chart annotation, experimental agent forums, per-role model selection, and a session-level audit log in one workspace. I am only naming it here, not unpacking it yet, because it deserves more than a passing mention.

The most distinctive page in the application is the one I have barely explained so far. The charts make the model visible. LLM Studio makes the interaction logic visible. That is where the design philosophy of the project becomes easiest to see, and it is the part of the interface I want to look at most closely.

## LLM Studio Deep Dive

If the rest of the application is about running and reading simulations, LLM Studio is about shaping the conversation between researcher and model. The page is organized as a unified workspace with role-specific tabs, a model configuration panel, staged request stores, and a session-level audit log. The interface keeps each role distinct because each role solves a different research problem and requires a different level of control.

<figure style="margin:1.85rem auto 1.7rem auto; width:100%; max-width:960px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/Illustration-2.png" alt="Sketchnote-style white-box boundary diagram showing four LLM roles staying at the model edge while a fifth enters through a small bounded norm-update valve." width="960" loading="lazy" style="display:block; width:100%; max-width:960px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Illustration 2 — The White-Box Boundary.</strong> LLM Roles 1 to 4 stay at the interface edges; LLM Role 5 enters the simulation only through a narrow, bounded valve.</figcaption></figure>

<figure style="margin:1.85rem auto 1.7rem auto; width:100%; max-width:960px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/Illustration-3.png" alt="Sketchnote-style workflow showing five LLM roles mapped to five stages of the research process around a central ABM dashboard." width="960" loading="lazy" style="display:block; width:100%; max-width:960px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Illustration 3 — Five LLM Roles in One Workflow.</strong> The five roles are not five chat tricks; they map onto five different points in the research workflow.</figcaption></figure>

### Role 1 — Scenario Parser

The first problem it solves is simple but important: researchers usually think in social descriptions before they think in parameter names. Role 1 gives them a place to start from natural language. In the interface, the user describes a society in plain English, the page stages a request, and the right-hand inspector returns structured values mapped onto a subset of `SimulationParams`. The output is not auto-applied in secret. The user reviews it and then decides whether to push those values into the Simulation Dashboard.

On the backend, `api/llm_service.py` calls the model with a constrained schema, and `api/schemas.py` defines the exact fields the model may fill. Missing values are allowed, which is a feature rather than a weakness. It means the system can admit uncertainty and fall back to neutral defaults instead of inventing precision.

The design principle here is that the LLM is translating *research language into parameter language*, not deciding the experiment for the user.

<figure style="margin:1.75rem auto 1.4rem auto; width:100%; max-width:1040px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/llm-studio-role-1.gif" alt="Animated walkthrough of LLM Studio Role 1 converting a free-text social scenario into structured simulation parameters with an explicit review step." width="1040" loading="lazy" style="display:block; width:100%; max-width:1040px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Role 1 — Scenario Parser.</strong> Role 1 turns a free-text social description into structured simulation parameters, with an explicit review step before anything reaches the dashboard.</figcaption></figure>

### Role 2 — Profile Generator

Role 2 tackles a different bottleneck: agent heterogeneity is easier to talk about in social terms than in numeric vectors. The interface lets a user describe one agent archetype and then returns a structured profile with delegation preference and four skill dimensions. The output is immediately legible as simulation input rather than generic prose.

What matters in implementation terms is that the interface does not pretend the LLM is "being the agent." It is generating inspectable attributes that can later be used to seed a model population. That distinction keeps the behavioral logic where it belongs: inside the `Resident` rules, not inside opaque dialogue.

The design principle is that LLMs are useful for **constructing explicit heterogeneity**, but the simulation should still run on visible rules.

<figure style="margin:1.75rem auto 1.4rem auto; width:100%; max-width:1040px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/llm-studio-role-2.gif" alt="Animated walkthrough of LLM Studio Role 2 converting a textual persona into simulation-ready attributes for agent heterogeneity." width="1040" loading="lazy" style="display:block; width:100%; max-width:1040px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Role 2 — Profile Generator.</strong> Role 2 converts a textual persona into simulation-ready attributes, making heterogeneity easier to define without turning the agent into a black box.</figcaption></figure>

### Role 3 — Result Interpreter

Role 3 is the most obviously conversational tab, but it is not a free-form chatbot. The user asks about the current run, and the interface bundles the question together with a compact simulation snapshot: recent metrics, current step, selected parameters, and conversation history. The returned answer is structured into a concise response, a fuller explanation, a hypothesis connection, and a confidence note.

That shape matters. It forces the interpretation layer to stay tied to the current experiment and to acknowledge methodological limits when needed. In other words, the role is not rewarded for sounding clever. It is rewarded for reconnecting visible metrics to explicit hypotheses and for stating caveats when a conclusion is still unstable.

The design principle is **mechanism-oriented interpretation**: use language to make results more legible, not to smuggle in a new causal theory.

<figure style="margin:1.75rem auto 1.4rem auto; width:100%; max-width:1040px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/llm-studio-role-3.gif" alt="Animated walkthrough of LLM Studio Role 3 interpreting the current simulation snapshot with linked metrics, hypotheses, and caveats." width="1040" loading="lazy" style="display:block; width:100%; max-width:1040px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Role 3 — Result Interpreter.</strong> Role 3 interprets the current simulation snapshot in context, connecting visible metrics to hypotheses and caveats rather than improvising detached commentary.</figcaption></figure>

### Role 4 — Visualization Annotator

This role exists because charts rarely explain themselves. A line can rise, flatten, or split for many reasons, and a research interface should help a reader reconnect the picture to the underlying mechanism. In the UI, the user can annotate all charts at once and watch cards fill in chart by chart.

What happens behind the scenes is the key design move: the program first computes summary facts from the chart data, and only then asks the LLM for a caption and one key insight. That ordering is crucial. The LLM is not deciding what the data says. The code computes the facts; the LLM translates them into clearer language.

The design principle is **facts first, language second**. That sounds modest, but it is exactly the kind of boundary that makes LLM integration usable in research settings.

<figure style="margin:1.75rem auto 1.4rem auto; width:100%; max-width:1040px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/llm-studio-role-4.gif" alt="Animated walkthrough of LLM Studio Role 4 generating chart annotations from computed summaries rather than direct free-form interpretation." width="1040" loading="lazy" style="display:block; width:100%; max-width:1040px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Role 4 — Visualization Annotator.</strong> Role 4 annotates charts from computed summaries, so the interface asks the LLM to explain facts rather than invent them.</figcaption></figure>

### Role 5 — Agent Forums

Role 5 is where the project becomes methodologically ambitious. Standard simulation runs keep norm adaptation fully rule-based. The forum mode introduces a deliberately bounded gray-box experiment: a sample of agents joins short small-group discussions, the system extracts a norm signal from each discussion, and that signal can nudge delegation preference by a capped amount.

The interface makes the experimental status impossible to miss. The tab is labeled **Experimental Mode**. The user controls forum fraction, exact or derived participant count, group count, and dialogue turns. The result is not a hidden update to the model state. It is a visible transcript workspace with group status, dialogue turns, extracted summaries, confidence values, and preference updates.

The backend logic in `model/forums.py` is equally explicit. The dialogue is short. The extracted outcome is structured. The update uses `delta = norm_signal * confidence * NORM_UPDATE_CAP`. Full audit visibility is preserved. That is what allows the role to exist without undermining the rest of the model. The project is not claiming that the LLM now *is* the social mechanism. It is testing whether a carefully bounded language layer changes the dynamics in a measurable way.

The design principle is **controlled gray-box experimentation**: if an LLM enters the loop, its influence must be limited, labeled, and inspectable.

<figure style="margin:1.75rem auto 1.4rem auto; width:100%; max-width:1040px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/llm-studio-role-5.gif" alt="Animated walkthrough of LLM Studio Role 5 running a bounded forum experiment with visible transcripts, extracted norm signals, and capped preference updates." width="1040" loading="lazy" style="display:block; width:100%; max-width:1040px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Role 5 — Agent Forums.</strong> Role 5 runs a bounded forum experiment with explicit transcripts, extracted norm signals, and capped preference updates visible in the interface.</figcaption></figure>

Across all five roles, one feature ties the page together: the audit log. Every role leaves behind a visible trace of model choice, timing, prompt payload, and result payload. That is not just a debugging convenience. It is the interface embodiment of a broader methodological stance: if LLMs are going to participate in the research workflow, their participation should be reviewable.

<figure style="margin:1.85rem auto 1.7rem auto; width:100%; max-width:960px;"><div style="background:#ffffff; border:1px solid #e5e7eb; border-radius:14px; padding:18px 18px 14px 18px; box-shadow:0 1px 2px rgba(15,23,42,0.06);"><img src="assets/images/blog-social-systems-04-building-interface-for-simulated-societies/Illustration-4.png" alt="Sketchnote-style audit trail diagram linking prompt, schema, LLM output, UI result, and research conclusion into one provenance chain." width="960" loading="lazy" style="display:block; width:100%; max-width:960px; height:auto; margin:0 auto;" /></div><figcaption style="margin-top:0.9rem; font-size:0.98rem; line-height:1.6; color:#475569; text-align:center;"><strong style="color:#0f172a;">Illustration 4 — Audit Trail as Research Infrastructure.</strong> Prompts, schemas, outputs, and UI actions are linked into a provenance chain rather than disappearing behind the interface.</figcaption></figure>

## Closing

What I wanted from this project was not just a nicer way to look at simulation output. I wanted an interface that could operate as part of the research method itself: configure scenarios, expose model behavior, manage runs, present findings, and integrate LLM assistance without surrendering the white-box clarity of the underlying ABM.

That is why I think of this application less as a dashboard and more as a small piece of research infrastructure. The simulation engine, GUI layer, visual analytics, LLM roles, and audit mechanisms are doing different jobs, but they are organized around one common task: helping a researcher move from question to experiment to explanation without losing sight of the assumptions in between.

If there is one lesson I take from building it, it is that interface design is not secondary to computational modeling. In projects like this, the interface is where transparency either survives or disappears. A good research interface does not simply make complex systems look better. It makes them easier to question. And in that sense, it is still doing what I care about most: making the invisible visible.

*This project explores abstract social dynamics and is not intended to characterize or evaluate any specific society, culture, or nation.*
