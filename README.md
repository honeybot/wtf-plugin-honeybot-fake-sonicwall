# Fake SonicWall SMA plugin for wtf

## Policy example

Mandatory options:
- version: version of SonicWall SMA to emulate. Currently only 9.0.0.0 supported.
- path: path to data folder (usually installed in /usr/local/share/wtf/data/)

```
{
    "name": "fake-sonicwall",
    "version": "0.1",
    "storages": { },
    "plugins": {            
        "honeybot.fake.sonicwall": [{
			"version": "9.0.0.0",
			"path":"/usr/local/share/wtf/data/honeybot/fake/sonicwall/"
		}]
    },
    "actions": {},
    "solvers": {}
}
```