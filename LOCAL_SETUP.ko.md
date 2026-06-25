# Freqtrade 로컬 실행 가이드

## 빠른 설치

```powershell
cd c:\cursor\aicryptotrader\freqtrade
.\scripts\setup-local.ps1
```

## 실행 (Dry-run)

```powershell
.\.venv\Scripts\Activate.ps1
freqtrade trade --config user_data/config.json --strategy SampleStrategy
```

- WebUI: http://127.0.0.1:8080
- 계정: `freqtrader` / `freqtrader`

## Windows 참고

- `pip install`이 멈추면 `--no-cache-dir --no-build-isolation` 옵션 사용
- async 거래소 연결 오류 시 `aiodns`, `pycares` 제거

## 배포

Freqtrade는 상시 실행 Python 봇이라 **Vercel(서버리스)에는 배포할 수 없습니다.**
Docker 또는 Render/VPS 같은 상시 실행 환경을 사용하세요.
