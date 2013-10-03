From: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH 2/6] Add shared update_fdt() function for ARM/ARM64
Date: Thu, 03 Oct 2013 10:57:35 -0400
Message-ID: <1380812255.17503.19.camel@deneb.redhat.com>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
 <1380385403-31904-3-git-send-email-roy.franz@linaro.org>
 <20131003095224.GX21381@console-pimps.org>
 <1380807804.17503.9.camel@deneb.redhat.com>
 <20131003142721.GB2781@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20131003142721.GB2781@console-pimps.org>
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
Cc: linux-efi@vger.kernel.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, Roy Franz <roy.franz@linaro.org>, matt.fleming@intel.com, grant.likely@linaro.org, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-10-03 at 15:27 +0100, Matt Fleming wrote:
> On Thu, 03 Oct, at 09:43:24AM, Mark Salter wrote:
> > On Thu, 2013-10-03 at 10:52 +0100, Matt Fleming wrote:
> > > > +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> > > > +static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
> > > > +                            void *fdt, int new_fdt_size, char *cmdline_ptr,
> > > > +                            u64 initrd_addr, u64 initrd_size,
> > > > +                            efi_memory_desc_t *memory_map,
> > > > +                            unsigned long map_size, unsigned long desc_size,
> > > > +                            u32 desc_ver)
> > > 
> > > Hmm... does this function really belong in efi-stub-helper.c? That file
> > > should be for architecture independent functionality only.
> > > 
> > 
> > It isn't really arm-specific although arm is the only user right now.
> > We're using the FDT to pass EFI boot info that is passed in the boot
> > params block on x86. So potentially other architectures could use the
> > same code.
> 
> It's not EFI-specific either, apart from the fdt property names.

Not EFI-specific in the sense that it uses the EFI services, but it is
EFI-specific in its function.

> 
> > How about making it someting like:
> > 
> > #ifdef ARCH_NEEDS_EFI_FDT
> > static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
> > ...
> > #endif
> > 
> > so the architecture can decide whether to include it or not.
> 
> Is one implementation of this function going to fit all architectures?
> Can we be sure of that ahead of time?
> 
> I'd prefer this to be kept in arch/ for now, and possibly moved into
> efi-stub-helper.c at a later date if indeed it turns out to be generally
> useful.

Fair enough. I don't have a strong opinion about it either way. Just a
natural instinct to share the code if possible, but it is easy enough
to change later if others want to use it.

--Mark
