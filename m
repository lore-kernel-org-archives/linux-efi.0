From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v4 24/28] x86: Access the setup data through debugfs
	decrypted
Date: Fri, 17 Mar 2017 14:54:56 -0500
Message-ID: <98ca8669-ddf0-b77c-8608-99bb5188cf73@amd.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
	<20170216154724.19244.71396.stgit@tlendack-t1.amdoffice.net>
	<20170308070459.GB11045@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170308070459.GB11045-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S.
	Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo
List-Id: linux-efi@vger.kernel.org

On 3/8/2017 1:04 AM, Dave Young wrote:
> On 02/16/17 at 09:47am, Tom Lendacky wrote:
>> Use memremap() to map the setup data.  This simplifies the code and will
>> make the appropriate decision as to whether a RAM remapping can be done
>> or if a fallback to ioremap_cache() is needed (which includes checking
>> PageHighMem).
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
>>  arch/x86/kernel/kdebugfs.c |   30 +++++++++++-------------------
>>  1 file changed, 11 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
>> index bdb83e4..c3d354d 100644
>> --- a/arch/x86/kernel/kdebugfs.c
>> +++ b/arch/x86/kernel/kdebugfs.c
>> @@ -48,17 +48,13 @@ static ssize_t setup_data_read(struct file *file, char __user *user_buf,
>>
>>  	pa = node->paddr + sizeof(struct setup_data) + pos;
>>  	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
>> -	if (PageHighMem(pg)) {
>> -		p = ioremap_cache(pa, count);
>> -		if (!p)
>> -			return -ENXIO;
>> -	} else
>> -		p = __va(pa);
>> +	p = memremap(pa, count, MEMREMAP_WB);
>> +	if (!p)
>> +		return -ENXIO;
>
> -ENOMEM looks better for memremap, ditto for other places..

Makes sense, I'll change them.

Thanks,
Tom

>
>>
>>  	remain = copy_to_user(user_buf, p, count);
>>
>> -	if (PageHighMem(pg))
>> -		iounmap(p);
>> +	memunmap(p);
>>
>>  	if (remain)
>>  		return -EFAULT;
>> @@ -127,15 +123,12 @@ static int __init create_setup_data_nodes(struct dentry *parent)
>>  		}
>>
>>  		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
>> -		if (PageHighMem(pg)) {
>> -			data = ioremap_cache(pa_data, sizeof(*data));
>> -			if (!data) {
>> -				kfree(node);
>> -				error = -ENXIO;
>> -				goto err_dir;
>> -			}
>> -		} else
>> -			data = __va(pa_data);
>> +		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
>> +		if (!data) {
>> +			kfree(node);
>> +			error = -ENXIO;
>> +			goto err_dir;
>> +		}
>>
>>  		node->paddr = pa_data;
>>  		node->type = data->type;
>> @@ -143,8 +136,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
>>  		error = create_setup_data_node(d, no, node);
>>  		pa_data = data->next;
>>
>> -		if (PageHighMem(pg))
>> -			iounmap(data);
>> +		memunmap(data);
>>  		if (error)
>>  			goto err_dir;
>>  		no++;
>>
>
> Thanks
> Dave
>
