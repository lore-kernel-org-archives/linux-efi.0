From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC PATCH 0/2] efi: add contents of LinuxExtraArgs EFI var to
 command line
Date: Thu, 12 Jul 2018 18:01:34 +0100
Message-ID: <20180712170134.GF26935@arm.com>
References: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180704154919.18564-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, Geoff Levand <geoff@infradead.org>, catalin.marinas@arm.com, Riku Voipio <riku.voipio@linaro.org>, Sudeep Holla <sudeep.holla@arm.com>, leif.lindholm@linaro.org, linux-acpi@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, James Morse <james.morse@arm.com>, Hanjun Guo <hanjun.guo@linaro.org>, Mark Salter <msalter@redhat.com>, linux-arm-kernel@lists.infradead.org, Ian Campbell <ijc@debian.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Wed, Jul 04, 2018 at 05:49:17PM +0200, Ard Biesheuvel wrote:
> As noted by Ian, many DMI based quirks for x86 ACPI machines disable
> features that can also be disabled via the kernel command line. Similarly,
> a quirk is under discussion for a arm64 ACPI machine [0] that explodes
> when enabling support for hardware error reporting via the ACPI HEST table.
> 
> When support for DMI tables was introduced to arm64 and ARM, the agreement
> was that they are informational only, i.e., provided to userland to describe
> the platform, not for keying off of to enable quirks in the kernel.
> 
> There are a couple of reasons for this:
> - Unlike the x86 architecture, where virtually all platforms are PC variants,
>   and the presence of ACPI and DMI tables may be assumed, the arm64 architecture
>   is much more heterogeneous, and none of UEFI, ACPI or DMI or actually mandated
>   or especially common across arm64 platforms; using DMI only makes sense for
>   working around a limited subset of platform issues that have to do with
>   firmware running on platforms that bother to implement it in the first place.
> - DMI is not initialized as early as it is on x86, and doing so is not trivial.
>   This means that even on ACPI/DMI machines, some issues may require quirks that
>   are enabled in a different way, or we need to refactor the DMI support so that
>   we can enable it as early as x86 does.
> - Using DMI tables fundamentally means quirking *after* the fact, which makes it
>   a moving target. Some quirks may require the DMI match table to be updated if
>   someone happens to change a string in the DMI tables when shipping a mostly
>   identical platform.
> 
> So instead, let's provide these platforms with the facilities required to enable
> such quirks at the platform level. Especially for UEFI systems, if upgrading
> firmware is a reasonable prerequisite for being able to upgrade to the latest
> kernel, having to run a script that sets a UEFI variable (either via the Linux
> command line of from the UEFI shell) should not be an unreasonable requirement
> either, and so we can solve part of this issue by configuring extra command line
> arguments persistenly from the firmware environment. This solves all the above
> issues in an unintrusive manner, given that the kernel command line is already
> made available extremely early in the boot, and the fact that it already permits
> a wide range of configuration options and overrides to be set, including the
> 'hest_disable=1' option that works around the issue addressed by [0].

I'm torn on this one. Whilst I strongly agree that keying off DMI tables
to detect firmware quirks is a bad idea on arm64, silently extending the
kernel command-line also has its downsides. The command-line provides ways
to override kernel defaults, so if a user has forced a feature on/off,
then I think this should take precedence over quirks and we should taint
instead, rather than silently override the option.

I'd be interested in other opinions on this.

Will
