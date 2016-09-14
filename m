From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v2 10/20] x86: Insure that memory areas are encrypted
	when possible
Date: Wed, 14 Sep 2016 09:11:13 -0500
Message-ID: <74d7fcd4-18e6-a81c-2510-bf0fe8a08a53@amd.com>
References: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
	<20160822223722.29880.94331.stgit@tlendack-t1.amdoffice.net>
	<20160909155305.bmm2fvw7ndjjhqvo@pd.tnic>
	<23855fb4-05b0-4c12-d34f-4d5f45f3b015@amd.com>
	<20160912163349.exnuvr7svsq7fmui@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160912163349.exnuvr7svsq7fmui-fF5Pk5pvG8Y@public.gmane.org>
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
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 09/12/2016 11:33 AM, Borislav Petkov wrote:
> On Mon, Sep 12, 2016 at 10:05:36AM -0500, Tom Lendacky wrote:
>> I can look into that.  The reason I put this here is this is all the
>> early page fault support that is very specific to this file. I modified
>> an existing static function to take advantage of the mapping support.
> 
> Yeah, but all this code is SME-specific and doesn't belong there.
> AFAICT, it uses global/public symbols so there shouldn't be a problem to
> have it in mem_encrypt.c.

Ok, I'll look into moving this into mem_encrypt.c. I'd like to avoid
duplicating code so I may have to make that static function external
unless I find a better way.

Thanks,
Tom

> 
>> Hmmm, maybe... With the change to the early_memremap() the initrd is now
>> identified as BOOT_DATA in relocate_initrd() and so it will be mapped
>> and copied as non-encyrpted data. But since it was encrypted before the
>> call to relocate_initrd() it will copy encrypted bytes which will later
>> be accessed encrypted. That isn't clear though, so I'll rework
>> reserve_initrd() to perform the sme_early_mem_enc() once at the end
>> whether the initrd is re-located or not.
> 
> Makes sense.
> 
