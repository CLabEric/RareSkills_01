## Why does the SafeERC20 program exist and when should it be used?

SafeERC20 was developed as a wrapper around normal ERC20 transfer functions to ensure a bool value is returned. It should be used when you can't guarantee that any ERC20 your contract may interact with returns value on transfer. SafeERC20 helps ensure reliable contract operations.
