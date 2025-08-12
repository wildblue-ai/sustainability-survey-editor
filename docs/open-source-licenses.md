# Open Source Licenses Used in Sustainability Survey Project

**Project**: Sustainability Survey CRUD Editor  
**Company**: WildBlue Enterprises LLC  
**Project License**: Proprietary  
**Generated**: 2025-08-11

## Production Dependencies

| Package | Version | License | Description | Comments | Repository Link |
|---------|---------|---------|-------------|----------|-----------------|
| **bcrypt** | ^6.0.0 | MIT | Password hashing library | No restrictions, fully compatible | [GitHub](https://github.com/kelektiv/node.bcrypt.js) |
| **body-parser** | ^1.20.2 | MIT | HTTP request body parsing middleware | No restrictions, fully compatible | [GitHub](https://github.com/expressjs/body-parser) |
| **cors** | ^2.8.5 | MIT | Cross-Origin Resource Sharing middleware | No restrictions, fully compatible | [GitHub](https://github.com/expressjs/cors) |
| **dotenv** | ^17.2.1 | BSD-2-Clause | Environment variable loader | Requires attribution, no name endorsement | [GitHub](https://github.com/motdotla/dotenv) |
| **express** | ^4.18.2 | MIT | Fast, unopinionated web framework | No restrictions, fully compatible | [GitHub](https://github.com/expressjs/express) |
| **express-basic-auth** | ^1.2.1 | MIT | Basic authentication middleware | No restrictions, fully compatible | [GitHub](https://github.com/LionC/express-basic-auth) |
| **express-session** | ^1.18.2 | MIT | Session middleware for Express | No restrictions, fully compatible | [GitHub](https://github.com/expressjs/session) |
| **mysql2** | ^3.6.5 | MIT | MySQL client for Node.js | No restrictions, fully compatible | [GitHub](https://github.com/sidorares/node-mysql2) |
| **uuid** | ^11.1.0 | MIT | UUID generation library | No restrictions, fully compatible | [GitHub](https://github.com/uuidjs/uuid) |

## Development Dependencies

| Package | Version | License | Description | Comments | Repository Link |
|---------|---------|---------|-------------|----------|-----------------|
| **nodemon** | ^3.0.2 | MIT | Development server auto-restart | No restrictions, dev-only usage | [GitHub](https://github.com/remy/nodemon) |

## Frontend Libraries (CDN)

| Library | Version | License | Description | Comments | Repository Link |
|---------|---------|---------|-------------|----------|-----------------|
| **Tailwind CSS** | 3.4.0 | MIT | Utility-first CSS framework | No restrictions, CDN usage only | [GitHub](https://github.com/tailwindlabs/tailwindcss) |
| **Font Awesome** | 6.0.0 | Multiple | Icon font library | **Mixed License**: Icons (CC BY 4.0 - attribution required), Fonts (SIL OFL 1.1 - free use), Code (MIT - no restrictions) | [GitHub](https://github.com/FortAwesome/Font-Awesome) |

## License Summary

### License Types Used:
- **MIT License**: 9 packages (90%)
- **BSD-2-Clause**: 1 package (10%)
- **Mixed (Font Awesome)**: 1 package

### License Compatibility:
✅ **All licenses are permissive and compatible with proprietary use**
✅ **No copyleft licenses (GPL, AGPL) that would require source disclosure**
✅ **All packages allow commercial use without restriction**

## License Obligations

### MIT License Requirements:
- Include copyright notice in redistributions
- Include license text in redistributions
- No warranty provided

### BSD-2-Clause Requirements:
- Include copyright notice in redistributions
- Include license text in redistributions  
- No endorsement using organization name

### Font Awesome License Requirements:
- **Icons (CC BY 4.0)**: Attribution required
- **Fonts (SIL OFL 1.1)**: Can be used freely
- **Code (MIT)**: Standard MIT requirements

## Compliance Notes

### For Distribution:
1. **Source Code**: Not required to be disclosed (all permissive licenses)
2. **Attribution**: Copyright notices should be included in about/credits section
3. **License Files**: Consider including in distribution package

### Recommended Actions:
1. **Add Attribution Page**: Create credits page listing all open source components
2. **Include License Files**: Store full license texts in `/docs/licenses/` directory
3. **Update Documentation**: Reference this file in deployment guides

## Full License Texts

Full license texts for all dependencies are available in the `/docs/licenses/` directory or can be viewed at:
- MIT License: https://opensource.org/licenses/MIT
- BSD-2-Clause: https://opensource.org/licenses/BSD-2-Clause
- CC BY 4.0: https://creativecommons.org/licenses/by/4.0/
- SIL OFL 1.1: https://scripts.sil.org/OFL

---

**Note**: This analysis covers direct dependencies only. For a complete analysis including transitive dependencies, run `npm audit` or use tools like `license-checker`.

**Last Updated**: 2025-08-11  
**Reviewed By**: Claude Code (Automated Analysis)