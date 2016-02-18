---
title: "Could the Mac App Store ease a transition from Intel to ARM?"
date: 2011-05-03
tags: "punditry Apple Mac OSX ARM Intel ISA SoC"
---
As Apple's ARM based system-on-chip (SOC) become ever more powerful, I'm not the only observer wondering if/when Apple will move their MacBooks away from Intel and over to a future generation of their ARM CPUs. What might the benefits be:
* Lower power consumption than Intel's equivalents enabling:
  * Longer battery life.
  * Eliminating the need for a fan.
  * Simplifying the design of the enclosure as heat dissipation is less critical.
  * Removing the need for a CPU heat sink.
  * Allowing for a thinner, lighter design.
* Massive integration on the SoC means that the component count is dramatically lower, simplifying and shrinking the circuit board and reducing the bill of materials.
* Large ARM ecosystems means that even if the Apple's Ax series of processors stops falls from its class-leading position,  Apple can choose parts from a large range of suppliers such as  [Qualcomm](http://www.qualcomm.com/news/releases/2011/02/14/qualcomm-announces-quad-core-snapdragon-next-generation-tablets-and), [Samsung](http://www.engadget.com/2010/09/07/samsungs-orion-is-the-1ghz-dual-core-arm-cortex-a9-weve-all-be/) etc.
* The ARM ecosystem results in a more competitive, innovative market than the Intel/AMD duopoly.

The problem with switching from Intel to ARM is that currently all the Mac software is compiled for Intel and will need to be recompiled for ARM. Apple eased the transition from PowerPC architecture to Intel by using dynamic translation in the form of [Rossetta](http://en.wikipedia.org/wiki/Rosetta_(software)). This enabled PowerPC applications to run on Intel Macs and gave application and peripheral driver developers time to recompile for Intel. The translation software was aided by moving to a more powerful CPU, which could affort to "waste" cycles translating without impacting end-user performance. However in any future shift to ARM, Apple will not have the luxury of performance improvements to hide the cost of the translation. This is where I think a thriving Mac App store comes into it's own and will enable the shift:
* Mac users become accustomed to loading their software via the App store.
* Populating a MacBook with your chosen applications becomes simply a matter of downloading all purchased applications - a single click.
* Apple pre-announces a range of super-sexy MacBooks based on ARM and encourages application developers to recompile for ARM and produce universal binaries containing Intel and ARM versions.
* Users with new ARM based MacBooks can download their chosen applications with a single click and don't need to know that their new ulta-thin, light, long battery life laptops use a completely different CPU architecture.

To summarise, the Mac App store could ease any transition by: 
* simple messaging to consumers: your favourite application is/isn't available for a particular machine.
* provide a conduit for communication with application developers to ensure a smooth transition.
* enable Apple to incentivise application developers to recompile for ARM.
* One click installation of all favourite applications.

Obviously this is all speculative and I doubt if the Mac App store was developed with a switch to ARM in-mind. However it's fascinating to note how once the App store infrastructure is in place, it can be an enabler for this kind of dramatic hardware migration.

The biggest barrier to such a switch would be 3rd party driver support. Perhaps Apple could use iOS AirPrint technology for printers and perhaps an ARM powered Macbook OS would more closely resemble iOS modified to use a keyboard rather than OSX. Such a modified iOS could skirt round the driver support issue by not including USB ports and instead making bluetooth and Wifi the only means of communication with peripherals. Then again perhaps dynamic translation from Intel to ARM instruction sets for only 3rd party peripheral drivers could be enabled without significantly impacting the end user experience.

Interesting times...
