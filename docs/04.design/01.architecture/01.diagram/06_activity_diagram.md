# 전체 워크플로우 Activity Diagram — 샘플서비스(공유 회의실 예약)

> **골격** — 흐름은 「공유 회의실 예약」 **예시**다. 실제 UC가 정해지면 Phase를 다시 그린다.

> **정본(source of truth)**: 이 문서의 §2 Mermaid 블록. **흐름 수정은 여기서만 한다**
> **상위 문서**: [04_use_case_diagram.md](04_use_case_diagram.md) (UC 집합) · [02_c4_container.md](02_c4_container.md) (컨테이너 이름)
> **작성 규칙**: [.claude/rules/architecture-diagram/activity-diagram](../../../../.claude/rules/architecture-diagram/activity-diagram)
> **상태**: 목표 상태 (골격)
> **작성일**: <YYYY-MM-DD>

Activity Diagram은 **UC들을 시간 순서 · 분기 · 예외로 엮은 흐름**이다. UC 하나하나의 정의와 실패 케이스 상세는 [05_use_case_scenarios](05_use_case_scenarios.md)가 가리키는 문서가 담당한다.

---

## 1. 레인과 표기

Mermaid `flowchart`에는 swimlane이 없다. 레인은 **노드 라벨의 액터 태그**로 표기하고, Phase는 `subgraph`로 구획한다. 액터 이름은 [01_c4_context](01_c4_context.md)의 Person 그대로다.

| 노드 색 | 뜻 |
| --- | --- |
| 파랑 | 정상 활동 |
| 노랑 | 예외 · 오류 · 재시도 · 사람 보정 |
| 분홍 마름모 | 분기 |

---

## 2. 전체 워크플로우 (정본)

```mermaid
flowchart TD
    PRE["공통 원칙<br/>모든 요청은 요청 경계를 먼저 지난다 (04 §4)<br/>재시도가 있는 저장은 멱등 키로 한 번만 저장"]
    START([시작]) --> P1_1

    subgraph P1["Phase 1 — 회의실 준비"]
        direction TB
        P1_1["UC-001 · 관리자<br/>회의실 이름 · 정원 입력"]
        P1_D1{"지운 회의실과<br/>같은 이름인가?"}
        P1_E1["새로 만들지 않고<br/>지운 회의실을 되살림"]
        P1_2["UC-001 · System<br/>회의실 저장"]

        P1_1 --> P1_D1
        P1_D1 -- 예 --> P1_E1
        P1_D1 -- 아니오 --> P1_2
    end

    P1_E1 --> P2_1
    P1_2 --> P2_1

    subgraph P2["Phase 2 — 회의실 예약"]
        direction TB
        P2_1["UC-002 · 사내 사용자<br/>회의실 · 시작 · 끝 · 목적 입력<br/>FR-001"]
        P2_D1{"같은 고유 번호로<br/>이미 저장됐는가?"}
        P2_E1["처음 저장한 예약을 그대로 돌려줌<br/>새로 만들지 않음 · FR-001"]
        P2_D2{"같은 회의실에<br/>겹치는 예약이 있는가?"}
        P2_E2["저장 거부<br/>겹친다고 안내 · FR-001"]
        P2_2["UC-002 · System<br/>예약 ACTIVE 저장 + 이력 CREATED"]
        P2_3["UC-003 · 사내 사용자<br/>연 버전으로 칸 고치기 · FR-002"]
        P2_D3{"버전이<br/>그대로인가?"}
        P2_E3["저장 거부<br/>사이에 바뀐 칸 표시 · FR-002"]
        P2_4["UC-003 · System<br/>칸 변경 + 버전 증가 + 이력 UPDATED"]
        P2_5["UC-004 · 사내 사용자<br/>사유를 적고 취소 · FR-003"]
        P2_6["UC-004 · System<br/>CANCELLED · 행은 남김 · 이력 CANCELLED"]
        P2_7["UC-005 · 사내 사용자<br/>기간 목록 · 변경 이력 보기<br/>FR-004 FR-005"]

        P2_1 --> P2_D1
        P2_D1 -- 예 --> P2_E1
        P2_D1 -- 아니오 --> P2_D2
        P2_D2 -- 예 --> P2_E2
        P2_D2 -- 아니오 --> P2_2 --> P2_3 --> P2_D3
        P2_D3 -- 아니오 --> P2_E3
        P2_E3 -- "다시 열어 고치기" --> P2_3
        P2_D3 -- 예 --> P2_4 --> P2_5 --> P2_6 --> P2_7
    end

    P2_E1 --> P2_7
    P2_E2 --> STOP_A([중단])
    P2_7 --> END([끝])

    subgraph ALWAYS["상시 — 알림 (정해진 주기)"]
        direction TB
        AL_1["UC-006 · System<br/>곧 시작할 ACTIVE 예약 찾기"]
        AL_D1{"발송 기록이<br/>이미 있는가?"}
        AL_2["UC-006 · System<br/>알림 발송 요청 + 발송 기록"]
        AL_E1["발송 실패 → 기록에 실패로 남김<br/>워커는 0이 아닌 코드로 종료"]

        AL_1 --> AL_D1
        AL_D1 -- 예 --> AL_SKIP([건너뜀])
        AL_D1 -- 아니오 --> AL_2
        AL_2 -- "실패" --> AL_E1
    end

    classDef act fill:#E3F2FD,stroke:#1565C0,color:#0D47A1
    classDef exc fill:#FFF8E1,stroke:#F57F17,color:#5D4037
    classDef dec fill:#FCE4EC,stroke:#C2185B,color:#880E4F
    classDef term fill:#ECEFF1,stroke:#546E7A,color:#263238
    classDef note fill:#EDE7F6,stroke:#5E35B1,color:#311B92

    class P1_1,P1_2,P2_1,P2_2,P2_3,P2_4,P2_5,P2_6,P2_7,AL_1,AL_2 act
    class P1_E1,P2_E1,P2_E2,P2_E3,AL_E1 exc
    class P1_D1,P2_D1,P2_D2,P2_D3,AL_D1 dec
    class START,END,STOP_A,AL_SKIP term
    class PRE note
```

---

## 3. Phase 정의

Phase 이름은 [04_use_case_diagram](04_use_case_diagram.md) §2와 **문자 그대로 같다**.

| Phase | 이름 | 포함 UC | 시작 조건 | 종료 상태 |
| :--: | --- | --- | --- | --- |
| 1 | 회의실 준비 | `UC-001` | 관리자가 로그인 | 예약할 수 있는 회의실이 있음 |
| 2 | 회의실 예약 | `UC-002`~`UC-005` | 사내 사용자가 로그인 | 예약이 `ACTIVE` 또는 `CANCELLED`이고 변경이 이력에 남음 |
| 상시 | 알림 | `UC-006` | 정해진 주기 | 곧 시작할 예약마다 알림이 한 번 감 |

순차 위치가 없는 활동(주기 작업 · 상시 조회)은 Phase로 줄 세우지 않고 별도 `subgraph`(「상시 — <이름>」)로 그린다.

## 4. 예외 분기 목록

| # | 분기 | 조건 | 처리 | 근거 |
| ---: | --- | --- | --- | --- |
| 1 | `P1_D1` | 지운 회의실과 같은 이름 | 되살린다 — 새 행을 만들지 않는다 | `.claude/rules/product-judgement` §2 |
| 2 | `P2_D1` | 같은 고유 번호의 재전송 | 처음 결과를 돌려준다 | `FR-001` |
| 3 | `P2_D2` | 겹치는 예약 | 거부한다 | `FR-001` |
| 4 | `P2_D3` | 버전 다름 | 거부하고 바뀐 칸을 보인다. 사람이 다시 연다 | `FR-002` |
| 5 | `AL_D1` | 이미 보낸 알림 | 건너뛴다 | <FR-###> |

## 5. 가정 · 자체 점검

| # | 항목 | 내용 |
| ---: | --- | --- |
| A-1 | 알림 시점 | 「곧」의 기준(시작 몇 분 전)이 FR에 없다. 수치를 발명하지 않고 비워 두었다 |
| 점검 | 흐름 정본 블록이 하나 · UC가 전부 04에 있음 | ✅ `scripts/check-diagrams.sh` 통과 |
| 점검 | 수치(재시도 횟수 · 기한)에 FR 번호가 있는가 | ✅ 수치 없음 |

요약 : 흐름은 **준비 → 예약 → 조회** 한 줄기와 주기로 도는 알림 하나이고, 분기 다섯 곳이 모두 「새로 만들지 않는다 · 거부한다 · 건너뛴다」 중 하나로 끝난다.
