# 01.diagram — 설계 다이어그램 색인

> **작성 규칙**: [.claude/rules/architecture-diagram/README](../../../../.claude/rules/architecture-diagram/README) · 작업 순서와 공통 구성은 [diagram-workflow](../../../../.claude/rules/architecture-diagram/diagram-workflow)
> **상태**: 골격 — 예시 도메인 「공유 회의실 예약」으로 채운 견본이다. SRS가 승인되면 01부터 다시 도출한다.

이 폴더의 문서는 **SRS(FR · NFR)를 구조로 옮긴 설계**다. 위에서 아래로만 이름을 물려받는다 — 01의 Person을 04가, 02의 컨테이너를 03 · 07 · 09 · 10이 그대로 쓴다. 정본은 문서 안 **Mermaid 블록**이고, 기술 스택은 여기서 정하지 않는다(스택 선택은 [ADR](../02.adr/README.md)).

| 번호 | 문서 | 답하는 질문 | 범위 |
| --- | --- | --- | --- |
| 01 | [01_c4_context.md](01_c4_context.md) | 누가 쓰고 무엇에 의존하는가 | 시스템 전체 |
| 02 | [02_c4_container.md](02_c4_container.md) | 어떤 실행 단위로 나뉘는가 (`CON-###`) | 시스템 전체 |
| 03 | [03_c4_component.md](03_c4_component.md) · [03a_component_api.md](03a_component_api.md) | 컨테이너 안의 모듈 경계 (`CMP-###`) · FR 대응 · 코드 모듈 매핑 | 컨테이너별 |
| 04 | [04_use_case_diagram.md](04_use_case_diagram.md) | 액터가 얻는 목표 (`UC-###`) | 시스템 전체 |
| 05 | [05_use_case_scenarios.md](05_use_case_scenarios.md) · [05a](05a_scenarios_phase1.md) · [05b](05b_scenarios_phase2.md) | UC별 주 흐름과 실패 케이스 | Phase별 |
| 06 | [06_activity_diagram.md](06_activity_diagram.md) | UC를 엮은 전체 흐름 · 분기 · 예외 | 시스템 전체 |
| 07 | [07_deployment_architecture.md](07_deployment_architecture.md) | 어디에 몇 개가, 어떤 경계에서 도는가 | 시스템 전체 |
| 09 | [09_data_flow_reservation.md](09_data_flow_reservation.md) | 데이터가 어디서 생겨 어디에 머무는가 | 기능별 |
| 10 | [10_sequence_reservation.md](10_sequence_reservation.md) | 시나리오 하나의 시간 순서 | 기능별 |

- 09 · 10은 외부 전송 · 비동기 · 사람 대기 · 개인정보가 있는 기능에만 만든다.
- 검사는 `scripts/check-diagrams.sh` 가 센다(집합 · 커버리지 · 링크 · Mermaid 블록). 문서에 건수를 손으로 옮겨 적지 않는다.
- 발표 · 검토용으로 다듬은 그림이 필요하면 archify 같은 렌더 플러그인을 추가로 쓸 수 있다. 그때도 정본은 Mermaid다.
