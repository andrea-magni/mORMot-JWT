# mORMot-JWT
[JWT](https://jwt.io) implementation (extracted from [mORMot](https://github.com/synopse/mORMot))

JWT is a technology used to build and verify web tokens in REST applications.
As I was looking for a better JWT library to be used into my [MARS-Curiosity REST library](https://github.com/andrea-magni/MARS) for Embarcadero Delphi, I decided to extract a small (yet significant) portion of [Synopse](http://synopse.info/) JWT implementation (used in the mORMot project) and have it as a separate repository.

Kudos to the authors of mORMot and specifically those who implemented JWT because this library is like ten times faster than the one I was using before and it does not have any external dependencies (thus not requiring OpenSSL deployment just to sign JWT tokens).
I am not an author of this code (I just tried to extract the smallest piece of code from mORMot able to implement JWT).

Unfortunately, the mORMot project runs on Linux through FPC and does not support using the Embarcadero LLVM ARC-enabled compiler so this option is viable only for Delphi Windows application servers (no Linux/OS X/mobile compatibility, so far).
