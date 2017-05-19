From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v5 17/32] x86/mm: Add support to access boot related data
	in the clear
Date: Fri, 19 May 2017 15:50:32 -0500
Message-ID: <c0cb8a50-e860-169b-ee0c-7eb4db7c3fda@amd.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
	<20170418211921.10190.1537.stgit@tlendack-t1.amdoffice.net>
	<20170515183517.mb4k2gp2qobbuvtm@pd.tnic>
	<4845df29-bae7-9b78-0428-ff96dbef2128@amd.com>
	<20170518090212.kebstmnjv4h3cjf2@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170518090212.kebstmnjv4h3cjf2-fF5Pk5pvG8Y@public.gmane.org>
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
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S.
	Tsirkin" <mst>
List-Id: linux-efi@vger.kernel.org

On 5/18/2017 4:02 AM, Borislav Petkov wrote:
> On Wed, May 17, 2017 at 01:54:39PM -0500, Tom Lendacky wrote:
>> I was worried what the compiler might do when CONFIG_EFI is not set,
>> but it appears to take care of it. I'll double check though.
>
> There's a efi_enabled() !CONFIG_EFI version too, so should be fine.
>
>> I may introduce a length variable to capture data->len right after
>> paddr_next is set and then have just a single memunmap() call before
>> the if check.
>
> Yap.
>
>> I tried that, but calling an "__init" function (early_memremap()) from
>> a non "__init" function generated warnings. I suppose I can pass in a
>> function for the map and unmap but that looks worse to me (also the
>> unmap functions take different arguments).
>
> No, the other way around: the __init function should call the non-init
> one and you need the non-init one anyway for memremap_is_setup_data().
>

The "worker" function would be doing the loop through the setup data,
but since the setup data is mapped inside the loop I can't do the __init
calling the non-init function and still hope to consolidate the code.
Maybe I'm missing something here...

Thanks,
Tom

>> This is like the chicken and the egg scenario. In order to determine if
>> an address is setup data I have to explicitly map the setup data chain
>> as decrypted. In order to do that I have to supply a flag to explicitly
>> map the data decrypted otherwise I wind up back in the
>> memremap_is_setup_data() function again and again and again...
>
> Oh, fun.
>
