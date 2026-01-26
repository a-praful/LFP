
# Sample C++ Project — GitHub Actions CI/CD only

This repository demonstrates a **GitHub Actions–only** CI/CD pipeline for a C++ project using **CMake/Make**, **GoogleTest**, **coverage enforcement** (lcov/gcov), **packaging** (CPack), and a simple **deploy** step, with **Slack/Email notifications**.

**Pipeline order:** Input → Checkout → Configure → Build → Test → Coverage → Package → Deploy → Post Actions

## GitHub configuration
Create the following **secrets/variables** in your repository:

**Secrets**
- `SLACK_WEBHOOK_URL` — Slack Incoming Webhook URL (optional)
- `SMTP_SERVER`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `MAIL_FROM` — for email notifications (optional)

**Variables**
- `MAIL_TO` — recipient email(s) for notifications (comma-separated)

> Deployment environment approvals can be enforced via **Environments** in repo settings (e.g., `dev`, `staging`, `prod`).

## Local build (optional)
```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug -DENABLE_COVERAGE=ON
cmake --build build -- -j$(nproc)
ctest --test-dir build --output-on-failure
./scripts/coverage.sh 70 build  # fail if < 70%
cmake --build build --target package
./scripts/deploy.sh build/*.tar.gz dev
```

## Structure
```
.
├── CMakeLists.txt
├── README.md
├── src/
│   └── main.cpp
├── tests/
│   └── test_sample.cpp
├── .github/
│   └── workflows/
│       └── cpp-ci.yml
└── scripts/
    ├── coverage.sh
    ├── package.sh
    └── deploy.sh
```
