# 유스케이스 시나리오 — 목차 — 샘플서비스(공유 회의실 예약)

> **골격** — 시나리오는 「공유 회의실 예약」 **예시**다.

> **상위 문서**: [04_use_case_diagram.md](04_use_case_diagram.md) (UC 인덱스 · 공통 사전조건)
> **하위 문서**: [05a_scenarios_phase1.md](05a_scenarios_phase1.md) · [05b_scenarios_phase2.md](05b_scenarios_phase2.md)
> **작성 규칙**: [.claude/rules/architecture-diagram/usecase](../../../../.claude/rules/architecture-diagram/usecase)
> **상태**: 목표 상태 (골격)
> **작성일**: <YYYY-MM-DD>

이 문서는 Phase 문서의 **목차와 공통 규칙**이다. UC 정의 · 주 흐름 · 실패 케이스의 본문은 Phase 문서 하나에 UC마다 한 절로 둔다. **실패 케이스가 본체다** — 주 흐름만 있는 UC는 미완성이다.

---

## 1. UC 개요

| UC | 이름 | 문서 | 실패 케이스의 핵심 |
| --- | --- | --- | --- |
| `UC-001` | 회의실 등록 · 수정 | [05a](05a_scenarios_phase1.md) | 지운 회의실과 같은 이름으로 다시 등록 |
| `UC-002` | 회의실 예약 만들기 | [05b](05b_scenarios_phase2.md) | 재전송(멱등) · 겹침 |
| `UC-003` | 예약 바꾸기 | [05b](05b_scenarios_phase2.md) | 버전 충돌 |
| `UC-004` | 예약 취소 | [05b](05b_scenarios_phase2.md) | 이미 취소된 예약 |
| `UC-005` | 예약 목록 · 변경 이력 보기 | [05b](05b_scenarios_phase2.md) | 빈 상태 · 남의 예약 |
| `UC-006` | 시작 전 알림 보내기 | [05b](05b_scenarios_phase2.md) | 발송 실패 · 워커 재시작 |

## 2. UC 절의 고정 구성

1. **정의 표** — 주 액터 · 사전조건 · 사후조건 · 대응 `CMP` · 근거 `FR` · 인터페이스.
2. **주 흐름 (목표)** — 번호 목록. 한 줄에 행위자 하나 · 동작 하나.
3. **실패 케이스 표** — `| 조건 | 시나리오(액터 관점) | 대응 FR · NFR |`. 재시도가 있는 흐름은 「같은 요청을 다시 보냄」 행이 반드시 있다.
4. (선택) 짧은 Mermaid 시퀀스 — 분기가 논점일 때만. 자세한 시간 순서는 `10_sequence_<기능>.md`.

구현이 끝난 UC에는 `(현행 코드)` 흐름을 더하거나 「현행 = 목표 (확인일)」 한 줄을 쓴다.

## 3. 확인 필요

| # | 질문 | 영향 UC | 상태 |
| ---: | --- | --- | --- |
| 1 | 이미 시작한 예약을 바꾸거나 취소할 수 있는가 | `UC-003` `UC-004` | 미결 — `docs/01.requirements/todo.md` 로 넘긴다 |

요약 : UC 여섯 개의 본문은 Phase 문서 둘에 있고, 실패 케이스 없는 UC는 완료가 아니다.
