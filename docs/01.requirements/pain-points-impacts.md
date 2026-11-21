# 결과 손실 (Impacts)

> **문서 코드**: `PNI` — 건수 · ID 범위는 [README §1](README.md#1-문서-지도)
> **원문**: [pain-points-root-causes.md](pain-points-root-causes.md) · [pain-points-amplifiers.md](pain-points-amplifiers.md)
> **연관**: [pain-points.md](pain-points.md) · [user-requirements.md](user-requirements.md)
> **작성일**: YYYY-MM-DD · **최종 개정**: YYYY-MM-DD

결과 손실은 원인과 증폭이 만나 **수익 · 경험 · 조직 중 어디서 측정되는 손실**이 되는지를 적는 층이다. 측정할 수 없는 「불편함」은 손실이 아니다. 각 행 끝의 `측정:` 꼬리가 `PRD` §3 성공 지표와 계측 계획의 입력이 된다.

```mermaid
graph LR
    PNR["PNR 근본 원인<br/>(제거 대상)"] --> PNA["PNA 증폭 요인<br/>(배가 구조)"]
    PNA --> PNI["PNI 결과 손실<br/>(측정 지점)"]
    style PNI fill:#1f6feb,color:#fff,stroke-width:3px
```

---

<!-- 카테고리 양식. 원인 열은 원인 × 증폭.

## PNI-1xx · <수익 · 비용 / 신뢰 · 경험 / 조직 · 확장> — "<별칭>"

| ID | 손실 유형 | 원인 | 출처 |
| --- | --- | --- | --- |
| PNI-101 | **<손실 이름>** — <서술>. 측정: <지표> | `PNR-101` × `PNA-101` | `PNP-00n` |

**핵심**: <한 줄>

**대응 REQ**

| Pain Point | 대응 REQ |
| --- | --- |
| PNI-101 | — |
-->

<!-- 예시(회의실 예약):
| PNI-101 | **회의 지연 · 취소** — 겹친 예약으로 한 팀이 다른 방을 찾느라 회의가 **평균 15분** 늦게 시작한다. 측정: 겹침 발생 건수, 회의 시작 지연 시간 | `PNR-101` × `PNA-101` | `PNP-003` |
-->

---

## 미대응 Pain Point

<단계 8에서 채운다>

---

요약 : <가장 큰 손실과 그것을 측정할 지표 한 줄>
