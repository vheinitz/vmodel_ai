# Rule: Coding Standards — Derived from Software Architecture

## Purpose
This rule defines mandatory coding standards for all implementation work in this project. Every standard here is **derived from software architecture principles**, not invented ad-hoc. Code that violates these standards is considered non-conformant to the architecture and must be refactored.

**Applies to**: Developer agent, any human developer contributing to `src/`.

---

## 0. The Prime Directive: Code Follows Architecture

> **Every source file must have a corresponding architectural element** in `project/02_Architecture/02_SoftwareArchitecture/` (component, interface, or data model). Code written without an architectural specification is **technical debt on arrival**.

Before implementing any module:
1. Read the software architecture document (`SW-SAD.md`)
2. Identify the component you are implementing
3. Understand its interfaces (provided + required)
4. Understand its safety class (A / B / C)
5. Implement ONLY what the architecture specifies — no extras, no shortcuts

---

## 1. Modularity & File Organization

### 1.1 One Class Per File (Cardinal Rule)

| Rule | Rationale |
|------|-----------|
| **One public class per `.hpp` / `.cpp` pair** | Enables independent compilation, review, testing, and replacement |
| **Exception**: Trivial helper structs/enums used ONLY by that class may live in the same header | Keep it under ~10 lines for helpers |
| **Exception**: Free functions forming a cohesive utility namespace may share a file | `<module>_utils.hpp` / `<module>_utils.cpp` |

```
✅ src/MainTool/workflow/ProtocolEngine.hpp   → class ProtocolEngine
✅ src/MainTool/workflow/ProtocolEngine.cpp
✅ src/MainTool/workflow/ProtocolTypes.hpp    → enum ProtocolState, struct ProtocolConfig
❌ src/MainTool/workflow/WorkflowClasses.hpp  → class ProtocolEngine, class StepRunner, class ...
```

### 1.2 Directory Structure Mirrors Architecture

```
src/<Component>/
├── <layer>/                     ← matches SW-SAD layer decomposition
│   ├── <ClassName>.hpp
│   ├── <ClassName>.cpp
│   └── tests/
│       └── test_<ClassName>.cpp
├── CMakeLists.txt               ← one per component
└── README.md                    ← component overview, build notes
```

**Layers** (from architecture — use the ones defined in your SW-SAD):
- `presentation/` — UI, views, view-models
- `business/` or `logic/` — workflow engine, calculations, protocol execution
- `data/` — repositories, ORM, data validation
- `communication/` — bus protocols, LIS/HIS, networking

### 1.3 Module = Replaceable Unit

Every source file pair (`.hpp` + `.cpp`) must be:
- **Self-contained**: Includes all its dependencies explicitly (no implicit includes)
- **Independently compilable**: The `.cpp` compiles with only its own `.hpp` and standard library
- **Replaceable**: A different implementation of the same interface can be swapped in without touching other files
- **Independently testable**: Has its own `test_<ClassName>.cpp` in `tests/`

**Rule**: If you cannot delete a `.cpp` file and replace it with a new implementation of the same header without modifying other source files, the module is too tightly coupled.

---

## 2. Interfaces — The Contract Between Modules

### 2.1 Interface Definition

Every module's public interface (its `.hpp`) is a **binding contract**:

```cpp
// ✅ Clear interface — consumer knows exactly what they get
class ProtocolEngine {
public:
    // Construction
    explicit ProtocolEngine(const EngineConfig& config);
    
    // Core operations
    Result<void> loadProtocol(const std::string& protocolId);
    Result<void> start();
    Result<void> pause();
    Result<void> abort();
    
    // Queries (const — no side effects)
    [[nodiscard]] ProtocolState state() const;
    [[nodiscard]] StepProgress currentProgress() const;
    
    // Events (Observer pattern — architecture-specified)
    void registerObserver(IProtocolObserver* observer);
    void unregisterObserver(IProtocolObserver* observer);
};
```

### 2.2 Interface Design Rules

| Rule | Rationale |
|------|-----------|
| **All public methods explicitly return error/success** | No silent failures. Use `Result<T>` or `std::expected<T, Error>` |
| **Queries are `const` and `[[nodiscard]]`** | Compiler enforces no side effects and result usage |
| **No public data members** | Encapsulation — data accessed through methods |
| **Abstract interfaces (pure virtual) for replaceable components** | Enables mocking, testing, and swapping implementations |
| **Interfaces are minimal** | Start with 3-5 methods; only add what consumers actually need |
| **Dependencies injected through constructor** | Never `new` inside a class; never reach for singletons |

### 2.3 Dependency Rule (Acyclic Dependencies Principle)

```
✅ Presentation → Business ← Data
   (Presentation depends on Business, Business does NOT depend on Presentation)

❌ Presentation ↔ Business
   (Circular dependency — architecture violation)
```

**Enforcement**: If component A includes a header from component B, B must NOT include anything from A. Violations are caught by the build system (CMake target dependencies).

---

## 3. Naming Conventions

### 3.1 Hierarchy

| Element | Convention | Example |
|---------|-----------|---------|
| **Namespace** | `snake_case` | `namespace helios::workflow` |
| **Class / Struct** | `PascalCase` | `ProtocolEngine`, `MotorController` |
| **Interface (pure virtual)** | `I` prefix + PascalCase | `IProtocolObserver`, `IDataRepository` |
| **Function / Method** | `snake_case` | `load_protocol()`, `current_progress()` |
| **Variable (local/member)** | `snake_case` | `engine_config`, `step_count` |
| **Private member variable** | `snake_case_` (trailing underscore) | `config_`, `state_`, `observers_` |
| **Constant / Enum value** | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT_MS` |
| **Enum type** | `PascalCase` | `enum class ProtocolState` |
| **Template parameter** | `T` or `PascalCase` | `T`, `ResultType` |
| **Header guard** | `NAMESPACE_COMPONENT_FILENAME_HPP_` | `HELIOS_WORKFLOW_PROTOCOL_ENGINE_HPP_` |
| **File name** | `PascalCase` matching class name | `ProtocolEngine.hpp`, `ProtocolEngine.cpp` |

### 3.2 Naming Quality Rules

- **No abbreviations** unless universally understood in the domain (`LIS`, `FMEA`, `GUI` — OK. `mgr`, `cfg`, `calc` — NO)
- **No Hungarian notation** (no `iCount`, `strName`, `pEngine`)
- **No type-encoding in names** (no `ptr_`, `shared_`, `vec_` — the type system handles this)
- **Boolean variables use `is_` / `has_` / `should_` prefix**: `is_running`, `has_slides`, `should_retry`

---

## 4. Function & Method Design

### 4.1 Size Limits (IEC 62304 / FDA Guidance)

| Metric | Limit | Rationale |
|--------|-------|-----------|
| **Lines per function** | ≤ 50 | Fits one screen — reviewable, testable, understandable |
| **Parameters per function** | ≤ 5 | Beyond 5 → group into a struct |
| **Cyclomatic complexity** | ≤ 10 | Beyond 10 → split into smaller functions |
| **Nesting depth** | ≤ 3 | Deep nesting → extract inner blocks into named functions |
| **Return points** | ≤ 2 | Single entry, single exit preferred for safety-critical (Class B/C) |

### 4.2 Parameter Best Practices

```cpp
// ❌ Too many parameters — what do these booleans even mean?
Result<void> move_axis(int axis_id, double target, double speed, 
                        bool wait, bool use_sensor, bool home_first);

// ✅ Group into a parameter struct
struct AxisMoveParams {
    int axis_id;
    double target_position;
    double speed_mm_s;
    bool wait_for_completion = true;
    bool use_limit_sensor = true;
    bool home_before_move = false;
};
Result<void> move_axis(const AxisMoveParams& params);
```

### 4.3 Control Flow (Safety-Critical Modules)

| Rule | Applies To |
|------|-----------|
| **No recursion** — all loops are bounded | Class B, C |
| **No `goto`** — exception: forward-only for cleanup in C firmware | Class B, C |
| **No dynamic memory allocation after initialization** | Class C |
| **All loops have provable upper bounds** | Class B, C |
| **No `switch` fall-through without explicit `[[fallthrough]]`** | All classes |
| **All `if` chains have an `else`** (even if just logging unexpected) | Class B, C |
| **`default` in every `switch` on enums** | All classes |

---

## 5. Error Handling

### 5.1 Error Strategy by Safety Class

| Safety Class | Preferred Strategy | Secondary |
|-------------|-------------------|-----------|
| **Class A** (no harm) | Exceptions allowed, `Result<T>` preferred for consistency | — |
| **Class B** (non-serious injury) | `Result<T>` / error codes | Exceptions only for unrecoverable (e.g., `std::bad_alloc`) |
| **Class C** (death/serious injury) | `Result<T>` / error codes ONLY | No exceptions in control flow |

### 5.2 Result Type Pattern

```cpp
// Mandatory for all modules with external interfaces
template <typename T>
class Result {
public:
    static Result success(T value);
    static Result error(ErrorCode code, std::string message);
    
    [[nodiscard]] bool is_ok() const;
    [[nodiscard]] bool is_error() const;
    
    T& value();              // undefined behavior if is_error()
    const ErrorCode& error() const;
    const std::string& message() const;
};

// Usage — every caller must check:
auto result = engine.start();
if (result.is_error()) {
    LOG_ERROR("Engine start failed: {}", result.message());
    return Result<void>::error(result.error(), "startup sequence aborted");
}
```

### 5.3 Error Categories

```cpp
enum class ErrorCode {
    // Hardware
    HARDWARE_NOT_RESPONDING,
    MOTOR_STALL,
    SENSOR_FAULT,
    
    // Data
    DATA_CORRUPTION,
    DATA_OUT_OF_RANGE,
    PROTOCOL_INVALID,
    
    // Communication
    BUS_TIMEOUT,
    LIS_DISCONNECTED,
    MESSAGE_MALFORMED,
    
    // Safety
    SAFETY_INTERLOCK_TRIGGERED,
    TEMPERATURE_EXCEEDED,
    PRESSURE_EXCEEDED,
    
    // System
    OUT_OF_MEMORY,
    INTERNAL_ERROR,
    NOT_IMPLEMENTED
};
```

---

## 6. Memory Management

### 6.1 Hierarchy (from least to most restrictive)

| Rule | Applies To |
|------|-----------|
| **No raw `new` / `delete` in application code** | All classes |
| **Use RAII for all resources** (memory, file handles, sockets, locks) | All classes |
| **Smart pointers**: `std::unique_ptr` for ownership, `std::shared_ptr` only where shared ownership is architecturally required | All classes |
| **No `malloc` / `free` in C++ code** | All classes |
| **C firmware: all allocations paired with explicit deallocation in same function scope** | Class B, C |
| **C firmware: dynamic allocation only during initialization** (Class C) | Class C |

### 6.2 Ownership Rules

```cpp
// ✅ Owner — unique_ptr, clear ownership
class MotorController {
    std::unique_ptr<ISerialPort> port_;   // MotorController owns the port

public:
    // Raw pointer for non-owning observation
    void register_monitor(IMotorMonitor* monitor);  // does NOT own
};
```

- **Owning**: `std::unique_ptr` (preferred) or `std::shared_ptr` (documented rationale required)
- **Non-owning**: Raw pointer or reference. Const where possible.
- **Never**: Raw pointer that owns (no `delete` in application code)

---

## 7. Logging & Observability

### 7.1 Structured Logging

```cpp
// ✅ Structured logging with severity
LOG_DEBUG("Axis {} moving to position {}", axis_id, target);
LOG_INFO("Protocol {} started for sample {}", protocol_id, sample_id);
LOG_WARN("Motor {} temperature approaching limit: {}°C", motor_id, temp);
LOG_ERROR("Bus communication timeout after {} retries", retry_count);
LOG_FATAL("Safety interlock triggered on axis {}", axis_id);
```

### 7.2 What to Log

| Event | Severity | Content |
|-------|----------|---------|
| Method entry (public API) | DEBUG | Method name, key parameters |
| Method exit (public API) | DEBUG | Return value on success |
| State transitions | INFO | Old state → new state, reason |
| Error conditions | ERROR | Error code, context, recoverable? |
| Safety events | WARN / FATAL | What triggered, what action taken |
| Performance metrics | INFO | Duration, throughput (sampled) |
| Configuration changes | WARN | Who, what, old → new value |

### 7.3 What NOT to Log

- Patient data / PHI (protected health information) — HIPAA/GDPR violation
- Full file paths on production systems (security)
- Passwords, tokens, keys
- Stack traces in release builds (can leak internals)
- In tight loops at DEBUG level (use TRACE or disable by default)

---

## 8. Thread Safety & Concurrency

### 8.1 Thread Model

Every class must document its thread model:

```cpp
/**
 * @brief Protocol execution engine.
 *
 * Thread model: Single-threaded — all public methods must be called
 * from the same thread. Internal state is not synchronized.
 * For multi-threaded access, wrap in a ProtocolEngineProxy.
 */
class ProtocolEngine { ... };
```

### 8.2 Synchronization Rules

| Rule | Rationale |
|------|-----------|
| **Prefer message-passing over shared state** | Enables deterministic testing |
| **Document which thread calls each method** | In header comment |
| **Use `std::mutex` + `std::lock_guard` for shared state** | RAII ensures unlock on exceptions |
| **No recursive mutexes** — they hide design problems | If you think you need one, refactor |
| **Atomic types for simple flags** | `std::atomic<bool>` for shutdown/heartbeat flags |
| **No busy-waiting / spin-locks** | Wastes CPU, hard to reason about |

---

## 9. Documentation Standards

### 9.1 Every Public Interface Must Have Doxygen

```cpp
/**
 * @brief Executes a laboratory assay protocol on loaded samples.
 *
 * Loads a protocol definition, initializes all hardware subsystems,
 * and orchestrates the step-by-step execution of the assay workflow.
 *
 * Thread model: Single-threaded.
 * Safety class: C — incorrect execution can lead to wrong patient results.
 *
 * @see ProtocolDefinition, IProtocolObserver
 */
class ProtocolEngine {
public:
    /**
     * @brief Load a protocol definition for execution.
     * @param protocol_id Unique identifier of the protocol to load.
     * @return Result<void> Success or error with reason.
     * @pre No protocol is currently executing.
     * @post Protocol is loaded and ready to start().
     */
    Result<void> loadProtocol(const std::string& protocol_id);
    
    // ...
};
```

### 9.2 Required Doxygen Tags

| Tag | When Required |
|-----|--------------|
| `@brief` | All public classes, methods, functions |
| `@param` | All parameters |
| `@return` | All non-void return values |
| `@pre` | Any precondition that must hold before calling |
| `@post` | Any postcondition guaranteed after successful call |
| `@throws` / `@error` | Documented error conditions |
| `@see` | Related classes, interfaces, or architecture docs |
| `@warning` | Safety-critical constraints or gotchas |

### 9.3 Internal Comments

- **WHY, not WHAT**: Code says WHAT; comments explain WHY
- **No commented-out code**: Dead code is a regulatory finding (IEC 62304). Delete it — git history preserves it.
- **No "TODO" without a ticket reference**: `// TODO(PROJ-123): Add retry logic for bus timeout`

---

## 10. Include Discipline

### 10.1 Include What You Use (IWYU)

```cpp
// ❌ Relies on transitive includes — fragile
#include "SomeBigHeader.hpp"  // happens to include <string>, <vector>

// ✅ Every used symbol has a corresponding include
#include <string>
#include <vector>
#include <memory>
#include "ProtocolEngine.hpp"
#include "IProtocolObserver.hpp"
```

### 10.2 Include Order

```cpp
// 1. Corresponding header (for .cpp files)
#include "ProtocolEngine.hpp"

// 2. Project headers (in dependency order)
#include "workflow/ProtocolTypes.hpp"
#include "workflow/IProtocolObserver.hpp"

// 3. Third-party / SOUP headers
#include <nlohmann/json.hpp>

// 4. Standard library headers
#include <string>
#include <vector>
#include <chrono>
```

### 10.3 Header Hygiene

- **Every header is self-contained**: `#include "Foo.hpp"` compiles without any prerequisite includes
- **Use `#pragma once`** (or include guards if project policy requires)
- **No `using namespace` in headers** — pollutes all includers
- **Minimal includes in headers**: Forward-declare when only pointer/reference is used

```cpp
// Foo.hpp
#pragma once
#include <memory>
#include <string>

// Forward declarations — avoids pulling in full headers
class Bar;           // Used as Bar* or Bar& in this header
struct BazConfig;    // Used as BazConfig in this header

class Foo {
    std::unique_ptr<Bar> bar_;
    void process(const BazConfig& config);
};
```

---

## 11. Safety-Critical Code Rules (Class B and C)

These rules apply to modules with **safety class B or C** as assigned in the SW-SAD.

### 11.1 Defensive Programming

| Rule | Rationale |
|------|-----------|
| **Validate ALL external inputs** | From sensors, LIS, user input, files, network |
| **Range-check ALL numeric parameters** | Before using as array index, buffer size, or motor position |
| **Null-check ALL pointers before dereference** | Even if "this should never be null" |
| **Default-initialize ALL variables** | `int count = 0;` not `int count;` |
| **Assert preconditions in debug; handle in release** | `assert()` for development; graceful error for release |
| **Double-check critical calculations** | Two independent implementations, or comparison with known-good |
| **CRC/checksum on stored/persisted data** | Detect corruption at rest |

### 11.2 Code Isolation

- **Safety-critical code in separate translation units** from non-safety code
- **Safety-critical data in protected memory regions** (if platform supports it)
- **No safety-critical code in signal/interrupt handlers** — set a flag, process in main loop
- **Watchdog timer for all safety-critical loops**

### 11.3 Compiler Warnings

```
// Build configuration for safety-critical modules:
-Wall -Wextra -Werror -Wpedantic
-Wconversion -Wsign-conversion
-Wdouble-promotion -Wformat=2
-Wimplicit-fallthrough
-Wnull-dereference
-fsanitize=undefined,address  // debug builds
```

**Zero warnings policy**: All safety-critical code must compile with zero warnings at these settings.

---

## 12. Code Review Checklist

Every pull request / code review must verify:

### Architecture Compliance
- [ ] Code corresponds to a documented architectural element in SW-SAD
- [ ] Module boundaries match architecture layers
- [ ] Dependencies flow in the correct direction (no cycles)
- [ ] Interfaces match the documented API specification

### Modularity
- [ ] One class per file (or justified helper exception)
- [ ] Module is independently compilable
- [ ] Module is replaceable without modifying consumers
- [ ] Header is self-contained

### Coding Standards
- [ ] Naming conventions followed (PascalCase classes, snake_case functions, etc.)
- [ ] Functions ≤ 50 lines, ≤ 5 parameters
- [ ] No raw `new`/`delete`
- [ ] IWYU: all includes explicit
- [ ] No commented-out code
- [ ] No `using namespace` in headers

### Safety (Class B/C)
- [ ] All inputs validated
- [ ] All loops bounded
- [ ] No recursion
- [ ] Error handling for all failure modes
- [ ] Default case in all switches
- [ ] Zero compiler warnings

### Tests
- [ ] Unit test file exists: `test_<ClassName>.cpp`
- [ ] All public methods have at least one test
- [ ] Error paths are tested (not just happy path)
- [ ] Test file is in `<component>/tests/` directory

### Documentation
- [ ] Doxygen on all public interfaces
- [ ] Thread model documented
- [ ] Safety class documented
- [ ] Preconditions and postconditions documented

---

## 13. Contradiction Resolution

Where multiple sources conflict, these rules resolve as follows:

| Conflict | Resolution | Rationale |
|----------|-----------|-----------|
| Exceptions vs. error codes | Error codes for Class B/C; exceptions allowed in Class A | Predictable control flow is paramount in safety-critical code. IEC 62304 and FDA guidance favor explicit error handling over exceptions. |
| `snake_case` vs `camelCase` for functions | `snake_case` for functions, `PascalCase` for classes | The majority of C++ standard library, Boost, and medical-device codebases use this convention. Consistency within the project is more important than external style preferences. |
| Free functions vs. static methods | Free functions in the same namespace | They don't require class instantiation and are easier to test in isolation. Group in `*_utils.hpp`. |
| Smart pointers everywhere vs. raw observing pointers | `unique_ptr` for ownership, raw pointer/reference for observation | This is the C++ Core Guidelines standard (R.3, F.7). No `shared_ptr` unless shared ownership is the domain requirement. |
| Header-only vs. separate compilation | `.hpp` + `.cpp` — separate compilation always | Faster incremental builds, clear interface/implementation separation, smaller object files. Template-only code is the only exception. |
| `#pragma once` vs. include guards | `#pragma once` (project default) | Supported by all modern compilers (GCC, Clang, MSVC). Less error-prone. If a specific audit requires classic guards, use both. |

---

## 14. References

- **IEC 62304:2006 + AMD1:2015** §5.4 (Detailed Design), §5.5 (Unit Implementation)
- **FDA General Principles of Software Validation** — §6 (Coding Standards)
- **MISRA C++:2008** — selected rules adapted for safety-critical C++
- **C++ Core Guidelines** (Stroustrup/Sutter) — especially F (Functions), I (Interfaces), R (Resource Management)
- **Johner Institut**: [Kodierrichtlinien für IEC 62304](https://www.johner-institut.de/blog/iec-62304-medizinische-software/kodierrichtlinien-iec-62304-fda/)
