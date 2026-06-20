# Contribution 6031: Cannot use instance of Singleton as default prop value

**Contribution Number:** 6031
**Student:** Liam Bagabag
**Issue:** https://github.com/sorbet/sorbet/issues/6031
**Status:** Phase III In-Progress

---

## Why I Chose This Issue

I chose this issue because the project tackles a problem that delves into
a basic aspect of compiler work/understanding. It is a project that is
genuinely interesting to me, and I hope that exploring the codebase will
help me learn more about the internals of code tooling like Sorbet.

---

## Understanding the Issue

### Problem Description

The issue I'm working on is a bug in the type checker's runtime that passes specific
syntax related to the `Singleton` class even though it should not be allowed.

### Expected Behavior

The type checker should correctly report the error.

### Current Behavior

Right now, the checker reports "No errors! Great job.".

### Affected Components

The related files involved all live within `gems/sorbet-runtime/lib/types/props`. 
This part of the codebase deals with the runtime library where the library
defines the bounds of a Singleton instance.

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

However, I realized that since the changes I propose is effective only at the
runtime level, there is no need to worry about building the binary.

For further clarification, the binary `sorbet` is a static type checker, while
`sorbet-runtime` is a library written in Ruby that runs alongside other ruby code
at *runtime*.

Therefore, contrary to my initial assumption, all we need to do is use the `bundle` utility
to fetch the dependencies and run the test suite of the project.

### Steps to Reproduce

1. Obtain the project dependencies. At most, `ruby` is required to be installed in the environment.
    - After reproducing the bug, I will doing future testing through a docker container. The prebuilt image is found at `docker.io/sorbetruby/sorbet-build-image:latest`.
2. Run the following provided script: `./test_singleton_default.sh`.
    - This script is a "manual" method of testing using the system environment to load the runtime library directly.
4. The result is that the runtime checker does not correctly catch the mistake, and ruby's runtime catches a generic type error.
    - see `./wk2-evidence-01.png`

### Reproduction Evidence

- **Commit showing reproduction:** https://github.com/lbzfran/sorbet/commits/fix-issue-6031/
- **Screenshots/logs:** `./wk2-evidence-01.png`
- **My findings:** The hardest part was actually building the project. It's a bit difficult specifically
    for my system due to the issues mentioned before. Once that was done, my next struggle was interacting
    with the container where the binaries live. I will probably work on the Dockerfile a bit more to
    make it easier for me before the next phase.
  - update: I realized the hard way that I don't need to create a Dockerfile (and it is now therefore deprecated). As mentioned before, since I am concerned only with the runtime library, I do not need to build the `sorbet` binary myself. This saves a lot of headaches in testing.

---

## Solution Approach

### Analysis

The cause is an inherent missing behavior in how the `Singleton` class is parsed/handled.

### Proposed Solution

Following the proposed solution of the maintainer who opened the issue, I will modify the parsing utility to prevent the behavior from passing as "good" by the checker.

As mentioned, the specific files related are the following:
- `gems/sorbet-runtime/lib/types/props/utils.rb`
- `gems/sorbet-runtime/lib/types/props/private/apply_default.rb`
- `gems/sorbet-runtime/lib/types/props/decorator.rb`

### Implementation Plan

Using UMPIRE framework (adapted):

**Understand:** The type checker incorrectly flags `Singleton` instance being used with as a default prop value as being correct behavior, when it is not.

**Match:** Most of the functions and classes found within `gems/sorbet-runtime/lib/types/props` have very similar structures, and it is definitely worth matching my proposal based on their working syntax. 

**Plan:** [Step-by-step implementation plan]
1. Modify the following three files (full path mentioned above): `utils.rb, apply_default.rb, decorator.rb`
2. Add the correct logic that would cause the behavior to be flagged.
3. Clean up the test cases to match the syntax/style of the codebase.

**Implement:** https://github.com/lbzfran/sorbet/commits/fix-issue-6031/

**Review:** The guidelines are pretty loose, and since the "good first issues" are well scoped, as long as I myself only work within the scope of the issue then there should be no issues.

**Evaluate:** The type checker must flag the test code being passed as having an actual error.
- My pull request will need to have an accompanying test case that properly evaluates the issue. I created an initial impromptu way to test, but for the final pull request I will need to adhere to the codebase standards (optional).

---

## Testing Strategy

### Unit Tests
I added two test cases within `test/types/props/optional.rb`.

To run these two test cases in the docker container, I ran the following command:
```sh
podman run --rm \        
  -v /home/liam/Projects/sorbet/gems/sorbet-runtime:/work \
  --workdir /work \
  docker.io/sorbetruby/sorbet-build-image:latest \
  bash -c "bundle install --quiet && bundle exec rake test"
```

- [ ] Test case 1: frozen singleton as default: verifies `Unset.instance.freeze` works and both instances share the same sentinel object.
- [ ] Test case 2: clear error for non-frozen non-cloneable default: verifies the improved TypeError message mentions `frozen` and `clone-able`.

### Integration Tests

- [ ] Integration scenario 1
- [ ] Integration scenario 2

### Manual Testing

I created a shell script that runs ruby on my machine, loads the runtime library, and runs the sample code provided in the issue and saved at `./test.rb`.
For the test to pass, the runtime checker must throw an error related to the Singleton props.

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
