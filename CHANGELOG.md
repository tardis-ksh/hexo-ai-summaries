# [2.0.0](https://github.com/tardis-ksh/hexo-ai-summaries/compare/v1.1.2...v2.0.0) (2026-07-30)

### Features

- support responses api and smooth streaming output ([bb0ea4c](https://github.com/tardis-ksh/hexo-ai-summaries/commit/bb0ea4cc98e7f39ca2365251220a630d99514c94))
- update deps ([bc421c5](https://github.com/tardis-ksh/hexo-ai-summaries/commit/bc421c5819f586bdedc8af91e80a33e130596324))

### BREAKING CHANGES

- 支持 response 响应、更新依赖

## [1.1.2](https://github.com/tardis-ksh/hexo-ai-summaries/compare/v1.1.1...v1.1.2) (2025-04-14)

### Bug Fixes

- use fn wrap ([aa3dd24](https://github.com/tardis-ksh/hexo-ai-summaries/commit/aa3dd24ee22fb32b6e81138d459209328d3857ce))

## [1.1.1](https://github.com/tardis-ksh/hexo-ai-summaries/compare/v1.1.0...v1.1.1) (2025-04-14)

### Bug Fixes

- rename stream ([8170f6a](https://github.com/tardis-ksh/hexo-ai-summaries/commit/8170f6ac0ea96d9ff02a6310d42882a65daf4cdf))

# [1.1.0](https://github.com/tardis-ksh/hexo-ai-summaries/compare/v1.0.0...v1.1.0) (2025-04-14)

### Features

- cancel space between code ([472a70e](https://github.com/tardis-ksh/hexo-ai-summaries/commit/472a70e66dd59a314a0f37d796ceda9781b1e7ef))

# [1.0.0](https://github.com/tardis-ksh/hexo-ai-summaries/compare/v0.10.0...v1.0.0) (2025-04-14)

### Features

- add version flag ([972ff94](https://github.com/tardis-ksh/hexo-ai-summaries/commit/972ff9415602639d53a7ea5f4de1f31dfc295956))
- support openAI response with json ([649331f](https://github.com/tardis-ksh/hexo-ai-summaries/commit/649331f9d7c4c64ecdb598ef7bfa78f92be2d19e))
- support or ([ab8101f](https://github.com/tardis-ksh/hexo-ai-summaries/commit/ab8101fd46e488a5cb4153d4c21a051e618e1204))

### BREAKING CHANGES

- refactor script.tpl

## rename fields

1. geminiConfig => aiConfig

## fields default value change

1. temperature => undefined(default 0.8)
2. headers => undefined(default object)
