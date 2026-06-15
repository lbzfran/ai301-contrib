# Contribution 6031: Cannot use instance of Singleton as default prop value

**Contribution Number:** 6031
**Student:** Liam Bagabag
**Issue:** [https://github.com/sorbet/sorbet/issues/6031]
**Status:** Phase II Complete

---

## Why I Chose This Issue

I chose this issue because the project tackles a problem that delves into
a basic aspect of compiler work/understanding. It is a project that is
genuinely interesting to me, and I hope that exploring the codebase will
help me learn more about the internals of code tooling like Sorbet.

---

## Understanding the Issue

### Problem Description

The issue I'm working on is a bug in the type checker that passes specific
syntax related to the `Singleton` class even though it should not be allowed.

### Expected Behavior

The type checker should correctly report the error.

### Current Behavior

Right now, the checker reports "No errors! Great job.".

### Affected Components

The related files involved all live within `gems/sorbet-runtime/lib/types/props`. This part of the codebase deals with the runtime library where the library
defines the bounds of a Singleton instance(s).

Specifically, the files involved are:
- `gems/sorbet-runtime/lib/types/props/utils.rb`
- `gems/sorbet-runtime/lib/types/props/private/apply_default.rb`
- `gems/sorbet-runtime/lib/types/props/decorator.rb`

---

## Reproduction Process

### Environment Setup

My working environment is a rolling linux distribution while the codebase
works on a pinned version of dependencies. This resulted in me being unable
to build the project through regular means.

Instead, I have opted to create a docker container to allow me to create
the binaries for this project. I will not however commit this dockerfile
in the final pull request.

### Steps to Reproduce

1. Build the project binaries using Docker.
    - see [./Dockerfile]
2. Pass the test file provided in the issue.
    - In my case, to do so through the Dockerfile: `$DOCKER run --rm -v $(pwd):/code sorbet /code/test.rb`
    - the test file has been pasted into `test.rb`.
    - see [./test.rb]
3. As the observed result suggests, the return value is: "No errors! Great job."
    - see [./wk2-evidence-01.png]

### Reproduction Evidence

- **Commit showing reproduction:** [Link to commit in your fork]
- **Screenshots/logs:** [./wk2-evidence-01.png]
- **My findings:** The hardest part was actually building the project. It's a bit difficult specifically
    for my system due to the issues mentioned before. Once that was done, my next struggle was interacting
    with the container where the binaries live. I will probably work on the Dockerfile a bit more to
    make it easier for me before the next phase.

---

## Solution Approach

### Analysis

[Your analysis of the root cause - what's causing the issue?]

### Proposed Solution

[High-level description of your fix approach]

### Implementation Plan

Using UMPIRE framework (adapted):

**Understand:** [Restate the problem]

**Match:** [What similar patterns/solutions exist in the codebase?]

**Plan:** [Step-by-step implementation plan]
1. [Modify file X to do Y]
2. [Add function Z]
3. [Update tests]

**Implement:** [Link to your branch/commits as you work]

**Review:** [Self-review checklist - does it follow the project's contribution guidelines?]

**Evaluate:** [How will you verify it works?]

---

## Testing Strategy

### Unit Tests

- [ ] Test case 1: [Description]
- [ ] Test case 2: [Description]
- [ ] Test case 3: [Description]

### Integration Tests

- [ ] Integration scenario 1
- [ ] Integration scenario 2

### Manual Testing

[What you tested manually and results]

---

## Implementation Notes

### Week [X] Progress

[What you built this week, challenges faced, decisions made]

### Week [Y] Progress

[Continue documenting as you work]

### Code Changes

- **Files modified:** [List]
- **Key commits:** [Links to important commits]
- **Approach decisions:** [Why you chose certain approaches]

---

## Pull Request

**PR Link:** [GitHub PR URL when submitted]

**PR Description:** [Draft or final PR description - much of the content above can be adapted]

**Maintainer Feedback:**
- [Date]: [Summary of feedback received]
- [Date]: [How you addressed it]

**Status:** [Awaiting review / Iterating / Approved / Merged]

---

## Learnings & Reflections

### Technical Skills Gained

[What you learned technically]

### Challenges Overcome

[What was hard and how you solved it]

### What I'd Do Differently Next Time

[Reflection on your process]

---

## Resources Used

- [Link to helpful documentation]
- [Tutorial or Stack Overflow post that helped]
- [GitHub issues or discussions that helped]
