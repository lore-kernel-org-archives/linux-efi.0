From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v2 07/20] x86: Provide general kernel support for
 memory encryption
Date: Thu, 8 Sep 2016 08:26:27 -0500
Message-ID: <bc8f22db-b6f9-951f-145c-fed919098cbe@amd.com>
References: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
 <20160822223646.29880.28794.stgit@tlendack-t1.amdoffice.net>
 <20160906093113.GA18319@pd.tnic>
 <f4125cae-63af-f8c7-086f-e297ce480a07@amd.com>
 <20160907155535.i7wh46uxxa2bj3ik@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160907155535.i7wh46uxxa2bj3ik-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dm
List-Id: linux-efi@vger.kernel.org

On 09/07/2016 10:55 AM, Borislav Petkov wrote:
> On Wed, Sep 07, 2016 at 09:30:54AM -0500, Tom Lendacky wrote:
>> _PAGE_ENC is #defined as sme_me_mask and sme_me_mask has already been
>> set (or not set) at this point - so it will be the mask if SME is
>> active or 0 if SME is not active.
> 
> Yeah, I remember :-)
> 
>> sme_early_init() is merely propagating the mask to other structures.
>> Since early_pmd_flags is mainly used in this file (one line in
>> head_64.S is the other place) I felt it best to modify it here. But it
>> can always be moved if you feel that is best.
> 
> Hmm, so would it work then if you stick it in early_pmd_flags'
> definition like you do with the other masks? I.e.,
> 
> pmdval_t early_pmd_flags = __PAGE_KERNEL_LARGE | _PAGE_ENC & ~(_PAGE_GLOBAL | _PAGE_NX);

When does this value get initialized?  Since _PAGE_ENC is #defined to
sme_me_mask, which is not set until the boot process begins, I'm afraid
we'd end up using the initial value of sme_me_mask, which is zero.  Do
I have that right?

Thanks,
Tom

> 
