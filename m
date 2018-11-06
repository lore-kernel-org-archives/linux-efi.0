From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 2/4] efi/arm: defer persistent reservations until after
 paging_init()
Date: Tue, 6 Nov 2018 23:49:33 +0000
Message-ID: <20181106234933.GO30658@n2100.armlinux.org.uk>
References: <20181106113732.16351-1-ard.biesheuvel@linaro.org>
 <20181106113732.16351-3-ard.biesheuvel@linaro.org>
 <CAKv+Gu8OsFb7a5UTovN1yBXtSSY=ZtUBYUvNa_bPmcZGknNYQA@mail.gmail.com>
 <20181106190817.GN30658@n2100.armlinux.org.uk>
 <CAKv+Gu_r38Bk_SZW-5qvtM7cmQ4-09dcFwNz29AyMceucdhadQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_r38Bk_SZW-5qvtM7cmQ4-09dcFwNz29AyMceucdhadQ@mail.gmail.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 06, 2018 at 09:06:56PM +0100, Ard Biesheuvel wrote:
> On 6 November 2018 at 20:08, Russell King - ARM Linux
> <linux@armlinux.org.uk> wrote:
> > On Tue, Nov 06, 2018 at 08:02:58PM +0100, Ard Biesheuvel wrote:
> >> On 6 November 2018 at 12:37, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >> > The new memory EFI reservation feature we introduced to allow memory
> >> > reservations to persist across kexec may trigger an unbounded number
> >> > of calls to memblock_reserve(). The memblock subsystem can deal with
> >> > this fine, but not before memblock resizing is enabled, which we can
> >> > only do after paging_init(), when the memory we reallocate the array
> >> > into is actually mapped.
> >> >
> >> > So break out the memreserve table processing into a separate function
> >> > and call if after paging_init() on both arm64 and ARM.
> >> >
> >> > Cc: Russell King <linux@armlinux.org.uk>
> >> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>
> >> Russell,
> >>
> >> If you are ok with this patch, may I have your ack please? I would
> >> like to send it out before the end of the week.
> >
> > You're not going to get a quick answer to this, because it needs me to
> > investigate what the effect of this change actually is by code review.
> > I can't guarantee when I'll get around to that.
> >
> 
> Fair enough.
> 
> I will drop the ARM hunk for now then, and we'll fix ARM when you have
> more time.

I don't see how you can do that - you're dropping the processing of
reserved areas out of the efi_config_parse_tables() path, so that
won't happen any more on ARM if you don't apply the ARM hunk.

So what I see at the moment is that efi_config_parse_tables() is
called prior to paging_init() - and prior to our memblock
initialisation, and you're proposing to move the processing that
marks blocks as reserved immediately after paging_init(), and
to use the normal memremap() interface to map stuff.

I'm not convinced this will work - the memory allocators have not
been setup at this point, so using memremap() will try to allocate
page tables and potentially fail.  If the normal allocators are
setup, it's way too late to be calling memblock_reserve() - the
memory will have been passed over to the page allocator according
to which memblocks are available but not reserved.

The normal page allocator is setup by mem_init(), which happens
way after setup_arch() has returned.

So, I don't see how your patch can be correct at the moment.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
