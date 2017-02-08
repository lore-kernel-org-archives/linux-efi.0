From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 06/10] arm64: efi: add EFI stub
Date: Wed, 8 Feb 2017 17:03:05 +0000
Message-ID: <20170208170305.GI15459@leverpostej>
References: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
 <1396637113-22790-7-git-send-email-leif.lindholm@linaro.org>
 <CAOZdJXWU1dmFfCc88RMp3SvouU7roDiJsA=3aHzwijwhMH7naA@mail.gmail.com>
 <E4BDBC23-A96A-4D84-B7EE-B7967D4E4DDD@linaro.org>
 <73a460e5-98f5-86c2-142f-a9a084ee0203@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <73a460e5-98f5-86c2-142f-a9a084ee0203@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Timur Tabi <timur@codeaurora.org>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, lkml <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 08, 2017 at 10:35:02AM -0600, Timur Tabi wrote:
> On 02/08/2017 10:29 AM, Ard Biesheuvel wrote:
> >>>>> +       status = handle_cmdline_files(sys_table, image, cmdline_ptr,
> >>>>> +                                     "initrd=", dram_base + SZ_512M,
> >>>>> +                                     (unsigned long *)&initrd_addr,
> >>>>> +                                     (unsigned long *)&initrd_size);
> >>>
> >>> So I know this patch is almost three years old, but why is there a
> >>> 512M limit on the initrd size?
> >>>
> >How do you reckon this constitutes a limit?
> 
> handle_cmdline_files() calls efi_high_alloc() with that limit.  I'm
> still trying to understand all the details myself, but apparently
> our firmware and initrd need to fit within the first 512MB because
> of dram_base + SZ_512M. When we change "dram_base + SZ_512M" to
> "~0", everything works.

Just to check, how big is that initrd?

I guess it's possible that there simply isn't sufficient contiguous free
memory in that range, even if the initrd isn't that large. Can you share
the EFI memory map dump from booting with efi=debug?

We originally needed to restrict this to ensure that the kernel could
map the initrd (and I think the 512M restriction specifically was
inherited from the DTB mapping restriction). Since then, we have relaxed
things in the kernel, and today Documentation/arm64/booting.txt says:

	If an initrd/initramfs is passed to the kernel at boot, it must
	reside entirely within a 1 GB aligned physical memory window of
	up to 32 GB in size that fully covers the kernel Image as well.

... so I think the EFI stub should be able to take advantage of that
relaxation.

Ard?

Thanks,
Mark.
