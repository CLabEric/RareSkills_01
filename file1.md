# ERC777 vs ERC1363

1. **What problems does each solve?**  
   Both ERCs include the ability for receivers to execute code when tokens are transferred.

2. **Why was ERC1363 introduced?**  
   To respond to transfers and approvals in ONE transaction instead of two. This saves gas.

3. **what issues are there with ERC777?**  
   Many people feel this ERC is too complicated and can easily lead to bugs. If a developer merely wants to take advantage of the hooks they still have to take care to avoid reentrancies and dos attacks.
