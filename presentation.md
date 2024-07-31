---
title: Technical introduction to Fedimint
sub_title: For Rust-Bitcoin Nashville
author: dpc (dpc@dpc.pw)
---

About Fedimint
===

![](./fedimint-banner.png)


* Federated E-Cash Mint 
* More generally: Module based system for building federated applications.

<!-- end_slide -->


Resources
===

![](./fedimint-banner.png)

* Github page: <https://github.com/fedimint/fedimint>
* Fedimint Reference Technical Documentation: <https://docs.fedimint.org>
* Discord Dev Chat: <https://discord.com/invite/Jq5dE2NhEd>

<!-- pause -->

Look up `CodeReferences` from this presentation in the Reference Documentation!

<!-- end_slide -->


Top-level architecture
===

![](./top-level.mmd.png)

* Client-Server architecture with multiple servers (consensus *Peer*s)
* Peers run *AlephBFT* consensus
* Clients communicate with peers in parallel to interact with the Federation
  * Usually but not always: require `T` of `M` matching responses (`QueryStrategy`)

<!-- pause -->

*Good time to ask questions about high level Fedimint operation.*

<!-- end_slide -->


`fedimintd` architecture (threads)
===

Main threads (`tokio` tasks):

* API Server
* Consensus
* Per-Peer networking

Communication between tasks through the database and in-memory channels.

<!-- end_slide -->


`fedimintd` architecture (database)
===

* `rocksdb` used on both server and client
* snapshot level isolation
* rich Rust wrapper logic around raw functionality: `Database`
* prefix-based partitioning

<!-- end_slide -->


`fedimintd` architecture (consensus)
===

* Fedimint consensus - like having own Federated blockchain
* AlephBFT ("atomic broadcast"): reliably orders `ConsensusItem`s:
  * `Transaction` (bunch of `DynInput`s and `DynOutput`s with a signature)
  * `DynModuleConsensusItem` - module specific consensus item
  * other (extensible, e.g. consensus version voting, etc.)
* `ConsensusItem`s gathered over few minutes into a `SessionOutcome`s, signed over
  into `SignedSessionOutcome`
* Naturally redundant and robust

<!-- pause -->

AlephBFT: <https://github.com/aleph-zero-foundation/AlephBFT>

<!-- end_slide -->


`fedimintd` architecture (consensus encoding)
===

* fork of `rust-bitcoin`'s `Encodable`
* schema-less, compact binary encoding
* supports module-extensible decoding via `Decoder`s in `ModuleDecoderRegistry`
* `derive` proc-macros 

<!-- end_slide -->


Fedimint Modules
===

* Federation = lightweight *core* + set of supported server side *modules* (`ModuleInitRegistry`)
* Modules have 2 sides: `ClientModule` and `ServerModule` (with some common shared types)
* `ClientModuleInit` and `ServerModuleInit` - "constructors"
* Has own Tx Inputs/Outputs, Consensus Items, APIs endpoints, versioning
* `ModuleKind` (like Unix binary/cmd) vs `ModuleInstanceId` (like Unix PID)
  * supported kinds added at compile-time
  * instance composition set during DKG (in the future: allow changing the composition on a running mint)
* module `Dyn`-types (e.g. `DynInput`, `DynModuleConsensusItem`)

<!-- end_slide -->


Fedimint Modules (cont.)
===

* Standard modules:
  * *mint* - ECash
  * *wallet* - on-chain multisig
  * *ln* and *lnv2* - Fedimint LN Gateway contracts
  * *meta* - metadata consensus module
* 3rd party modules (that we know of):
  * stabilitypool (Fedi)
  * social recovery (Fedi)
  * escrow module (Summer of Bitcoin project)

<!-- end_slide -->


`fedimint-client` architecture (state machines)
===

* client = client *core* + set of supported client side *modules* (`ClientModuleInitRegistry`)
* all client interactions modeled as persistent state machines
* idempotent steps
* event log
* *state machine executor* polling all state machines to completion

<!-- end_slide -->


Code overview: `fedimint-server` ("`fedimintd` without modules")
===

![](dependency_graph_fedimint-server.png)

<!-- end_slide -->


Code overview: `fedimintd`
===

![](dependency_graph_fedimintd.png)

<!-- end_slide -->


Code overview: `fedimint-client` (FDK?, "client lib without modules")
===

![](dependency_graph_fedimint-client.png)


<!-- end_slide -->

Code overview: `fedimint-cli` (command line app)
===

![](dependency_graph_fedimint-cli.png)

<!-- end_slide -->

Points of Interest
===

* `devimint` and e2e testing, including component version
  compat matrix testing and upgrade tests
* encoding fuzzing
* Client backups and recovery
* Nix & elaborated CI
