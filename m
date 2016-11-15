From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v3 04/20] x86: Handle reduction in physical address
	size with SME
Date: Tue, 15 Nov 2016 10:06:16 -0600
Message-ID: <bb47e943-f5b6-0d73-cf9a-fea002a5c70e@amd.com>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
	<20161110003513.3280.12104.stgit@tlendack-t1.amdoffice.net>
	<20161115121035.GD24857@8bytes.org>
	<20161115121456.f4slpk4i2jl3e2ke@pd.tnic>
	<a4cc5b07-89e1-aaa0-1977-1de95883ba62@amd.com>
	<20161115153338.a2cxmatnpqcgiaiy@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20161115153338.a2cxmatnpqcgiaiy-fF5Pk5pvG8Y@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11/15/2016 9:33 AM, Borislav Petkov wrote:
> On Tue, Nov 15, 2016 at 08:40:05AM -0600, Tom Lendacky wrote:
>> The feature may be present and enabled even if it is not currently
>> active.  In other words, the SYS_CFG MSR bit could be set but we aren't
>> actually using encryption (sme_me_mask is 0).  As long as the SYS_CFG
>> MSR bit is set we need to take into account the physical reduction in
>> address space.
> 
> But later in the series I see sme_early_mem_enc() which tests exactly
> that mask.

Yes, but that doesn't relate to the physical address space reduction.

Once the SYS_CFG MSR bit for SME is set, even if the encryption bit is
never used, there is a physical reduction of the address space. So when
checking whether to adjust the physical address bits I can't rely on the
sme_me_mask, I have to look at the MSR.

But when I'm looking to decide whether to encrypt or decrypt something,
I use the sme_me_mask to decide if that is needed.  If the sme_me_mask
is not set then the encrypt/decrypt op shouldn't be performed.

I might not be grasping the point you're trying to make...

Thanks,
Tom

> 
> And in patch 12 you have:
> 
> +       /*
> +        * If memory encryption is active, the trampoline area will need to
> +        * be in un-encrypted memory in order to bring up other processors
> +        * successfully.
> +        */
> +       sme_early_mem_dec(__pa(base), size);
> +       sme_set_mem_unenc(base, size);
> 
> What's up?
> 
> IOW, it all sounds to me like you want to have an sme_active() helper
> and use it everywhere.
> 
