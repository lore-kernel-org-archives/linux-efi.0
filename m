From: Ian Campbell <ijc@debian.org>
Subject: Re: [RFC PATCH 0/2] efi: add contents of LinuxExtraArgs EFI var to
 command line
Date: Thu, 12 Jul 2018 20:24:19 +0100
Message-ID: <1531423459.3582.15.camel@debian.org>
References: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
 <20180712170134.GF26935@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180712170134.GF26935@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, Geoff Levand <geoff@infradead.org>, catalin.marinas@arm.com, Riku Voipio <riku.voipio@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>, leif.lindholm@linaro.org, linux-acpi@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, James Morse <james.morse@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>, Mark Salter <msalter@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2018-07-12 at 18:01 +0100, Will Deacon wrote:
On Wed, Jul 04, 2018 at 05:49:17PM +0200, Ard Biesheuvel wrote:
> >                                    Especially for UEFI systems, if upgrading
> > firmware is a reasonable prerequisite for being able to upgrade to the latest

Is it?

There's zero chance that there will be new firmware for the system in
question, but even if there were I'm not sure it should be considered a
n at all reasonable thing to ask in the general case (I know that if
x86 jumped off a cliff ARM wouldn't follow, but it certainly isn't
considered reasonable in the common case in that world).

> I'm torn on this one. Whilst I strongly agree that keying off DMI tables
> to detect firmware quirks is a bad idea on arm64, silently extending the
> kernel command-line also has its downsides. The command-line provides ways
> to override kernel defaults, so if a user has forced a feature on/off,
> then I think this should take precedence over quirks and we should taint
> instead, rather than silently override the option.
> 
> I'd be interested in other opinions on this.

FWIW it seems to me that if we aren't going to have these systems Just
work with newer kernels and instead require users to perform some sort
of reconfiguration (which seems like a great shame to me, but I'll let
that horse lie[0]) then it seems like they can just as easily add this
command line parameter via existing mechanisms (/etc/default/grub etc)
without needing to invent some new way of doing so (one which is more
obscure and perhaps harder to configure).

Likewise distros, they can chose to either require their users to make
those changes (see above), or they can choose not to support those
systems any more or to not enable the config options which expose the
issue.

Ian.

[0] OK, I will just mention that I don't believe it needs to be a DMI
quirk -- if there were some other way to detect and make things just
work then that would be great too. Now I'm done with the horse.
