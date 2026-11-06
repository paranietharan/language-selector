# Backend Language Selector — CLIPS

A university expert-system assignment that uses CLIPS facts and rules to suggest backend programming languages from a user's answers. The recommendations demonstrate rule-based reasoning; the scores are authored heuristics, not benchmarks or universal language rankings.

## What it demonstrates

- Templates for questions, answers, and recommendations.
- Rules based on project type, experience, performance needs, team size, and development speed.
- An interactive console questionnaire with scored recommendations and explanations.

## Run locally

Install a CLIPS interpreter, then clone this repository:

```bash
git clone https://github.com/paranietharan/language-selector.git
cd language-selector
```

Start CLIPS with this directory as its working directory. At the CLIPS prompt, enter:

```clips
(clear)
(load "language-selector.clp")
(main)
```

These are CLIPS commands, not shell commands. If your interpreter starts elsewhere, load the file using its actual local path. The `main` function calls `reset` and `run` itself. Enter the answer tokens exactly as shown in each question, such as `Web-API`, `Beginner`, or `Small-team`.

## Source and limitations

The full program is in [language-selector.clp](language-selector.clp). Rules and question options are hardcoded, and there is no automated test suite. The output rules retract recommendations after printing them; consequently, the fallback message can also appear after matched results. Treat this as a learning implementation.

See the companion [Python/Tkinter version](https://github.com/paranietharan/language-selector-python) for a graphical implementation of the same learning topic.
