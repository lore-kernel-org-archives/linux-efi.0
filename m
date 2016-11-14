From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v3 02/20] x86: Set the write-protect cache mode for
	full PAT support
Date: Mon, 14 Nov 2016 10:51:27 -0600
Message-ID: <01f705f1-484b-4407-7b7a-e8e69966581f@amd.com>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
	<20161110003448.3280.27573.stgit@tlendack-t1.amdoffice.net>
	<20161110131400.bmeoojsrin2zi2w2@pd.tnic>
	<1478827480.20881.142.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1478827480.20881.142.camel-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org" <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org" <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <dvyukov@g>
List-Id: linux-efi@vger.kernel.org

On 11/10/2016 07:26 PM, Kani, Toshimitsu wrote:
> On Thu, 2016-11-10 at 14:14 +0100, Borislav Petkov wrote:
>> + Toshi.
>>
>> On Wed, Nov 09, 2016 at 06:34:48PM -0600, Tom Lendacky wrote:
>>>
>>> For processors that support PAT, set the write-protect cache mode
>>> (_PAGE_CACHE_MODE_WP) entry to the actual write-protect value
>>> (x05).
> 
> Using slot 6 may be more cautious (for the same reason slot 7 was used
> for WT), but I do not have a strong opinion for it.
> 
> set_page_memtype() cannot track the use of WP type since there is no
> extra-bit available for WP, but WP is only supported by
> early_memremap_xx() interfaces in this series.  So, I think we should
> just document that WP is only intended for temporary mappings at boot-
> time until this issue is resolved.  Also, we need to make sure that
> this early_memremap for WP is only called after pat_init() is done.

Sounds good, I'll add documentation to cover these points.

> 
> A nit - please add WP to the function header comment below.
> "This function initializes PAT MSR and PAT table with an OS-defined
> value to enable additional cache attributes, WC and WT."

Will do.

Thanks,
Tom

> 
> Thanks,
> -Toshi
> 
