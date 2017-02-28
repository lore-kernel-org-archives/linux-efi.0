From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 0/2] efi: Enhance capsule loader to support signed Quark
 images
Date: Tue, 28 Feb 2017 12:29:47 +0000
Message-ID: <20170228122947.GE28416@codeblueprint.co.uk>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
 <CAHp75VeVZo8f_aXZ=R8Y+++RSQeT=tFZmL6NNfekKJTkJc-nZA@mail.gmail.com>
 <1bf3c9d8-56aa-818b-350f-deb62ad14e08@siemens.com>
 <4014c5e6-b5a0-7552-166f-a42992532c09@siemens.com>
 <F54AEECA5E2B9541821D670476DAE19C5DE533B3@PGSMSX102.gar.corp.intel.com>
 <f4f63644-e099-b192-5337-15c07d761fb4@nexus-software.ie>
 <F54AEECA5E2B9541821D670476DAE19C5DE5373E@PGSMSX102.gar.corp.intel.com>
 <5da59d02-d299-f5c7-48fa-a67bdd017252@siemens.com>
 <20170228121255.GD28416@codeblueprint.co.uk>
 <fb94de5b-e359-ab8d-bb9b-52efcad91bc5@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fb94de5b-e359-ab8d-bb9b-52efcad91bc5@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, Andy Shevchenko <andy.shevchenko@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, "Mok, Tze Siong" <tze.siong.mok@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 28 Feb, at 01:20:25PM, Jan Kiszka wrote:
> 
> From you POV, does this exclude upstream quirk support for already
> shipped devices?

It would need to be an extremely small, well-contained change, that
had no chance of disrupting other users of the capsule interface and
where I had a good feeling that supporting it wouldn't turn into a
maintenance nightmare (mountains of DMI strings or new platforms
coming to market that used it).

That's a tall order, and I'm pretty skeptical. Still, I'll never say
never. Plus Ard would need convincing to give his ACK too.

P.S. Has anyone actually investigated what would be required to fix
the firmware to be able to extract the CSH if it was contained inside
a capsule?
