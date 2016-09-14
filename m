From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v2 19/20] x86: Access the setup data through debugfs
 un-encrypted
Date: Wed, 14 Sep 2016 09:29:41 -0500
Message-ID: <4a357b9b-7d53-5bd6-81db-9d8cc63a6c72@amd.com>
References: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
 <20160822223859.29880.60652.stgit@tlendack-t1.amdoffice.net>
 <20160912165944.rpqbwxz2biathnt3@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160912165944.rpqbwxz2biathnt3-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dm
List-Id: linux-efi@vger.kernel.org

On 09/12/2016 11:59 AM, Borislav Petkov wrote:
> On Mon, Aug 22, 2016 at 05:38:59PM -0500, Tom Lendacky wrote:
>> Since the setup data is in memory in the clear, it must be accessed as
>> un-encrypted.  Always use ioremap (similar to sysfs setup data support)
>> to map the data.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
>>  arch/x86/kernel/kdebugfs.c |   30 +++++++++++-------------------
>>  1 file changed, 11 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
>> index bdb83e4..a58a82e 100644
>> --- a/arch/x86/kernel/kdebugfs.c
>> +++ b/arch/x86/kernel/kdebugfs.c
>> @@ -48,17 +48,13 @@ static ssize_t setup_data_read(struct file *file, char __user *user_buf,
>>  
>>  	pa = node->paddr + sizeof(struct setup_data) + pos;
>>  	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
>> -	if (PageHighMem(pg)) {
> 
> Why is it ok to get rid of the PageHighMem() check?

Since the change is to perform the ioremap call no matter what the check
for PageHighMem() wasn't needed anymore.

> 
> Btw, we did talk earlier in the thread about making __va() clear the SME
> mask and then you won't really need to change stuff here. Or?

This is still required because just using the __va() would still cause
the mapping created to have the encryption bit set. The ioremap call
will result in the mapping not having the encryption bit set.

Thanks,
Tom

> 
