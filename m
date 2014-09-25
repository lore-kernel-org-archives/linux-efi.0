From: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 7/7] efi_rtc: probe function error out in case no efi
 runtime enabled
Date: Thu, 25 Sep 2014 17:38:50 -0400
Message-ID: <1411681130.25340.101.camel@deneb.redhat.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007953-15151-1-git-send-email-dyoung@redhat.com>
 <1411403609.25340.55.camel@deneb.redhat.com>
 <20140925211855.GS18635@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20140925211855.GS18635@console-pimps.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Russ Anderson <rja@sgi.com>, Alessandro Zummo <a.zummo@towertech.it>, linux-efi@vger.kernel.org, rtc-linux@googlegroups.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Daniel Kiper <daniel.kiper@oracle.com>, Randy Dunlap <rdunlap@infradead.org>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Ingo Molnar <mingo@redhat.com>, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Dave Young <dyoung@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-09-25 at 22:18 +0100, Matt Fleming wrote:
> On Mon, 22 Sep, at 12:33:29PM, Mark Salter wrote:
> > 
> > Is this still needed after commit da167ad7638759:
> > 
> >   rtc: ia64: allow other architectures to use EFI RTC
> 
> Umm... we should really look at disabling this for x86, since the EFI
> time functions don't work on a bunch of machines I've got here.
> 
> And it looks like someone enabled this driver and triggered an oops on
> their 32-bit EFI tablet,
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=84241#c21

Previously, it depended on IA64. If it's not worth the trouble for
x86 then I'd say have it depend on !X86 also. Newer EFI-supporting
architectures are unlikely to have the same legacy issues as x86
so I don't think it'll end up being an ever growing list.
