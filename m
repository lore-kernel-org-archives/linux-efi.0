From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v10 00/38] x86: Secure Memory Encryption (AMD)
Date: Tue, 18 Jul 2017 09:02:08 -0500
Message-ID: <d43d315c-6797-b51e-58a8-05b5f98951d0@amd.com>
References: <cover.1500319216.git.thomas.lendacky@amd.com>
	<alpine.DEB.2.20.1707181402340.1945@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1707181402340.1945@nanos>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel@vg
List-Id: linux-efi@vger.kernel.org

On 7/18/2017 7:03 AM, Thomas Gleixner wrote:
> On Mon, 17 Jul 2017, Tom Lendacky wrote:
>> This patch series provides support for AMD's new Secure Memory Encryption (SME)
>> feature.
>>
>> SME can be used to mark individual pages of memory as encrypted through the
>> page tables. A page of memory that is marked encrypted will be automatically
>> decrypted when read from DRAM and will be automatically encrypted when
>> written to DRAM. Details on SME can found in the links below.
>>
>> The SME feature is identified through a CPUID function and enabled through
>> the SYSCFG MSR. Once enabled, page table entries will determine how the
>> memory is accessed. If a page table entry has the memory encryption mask set,
>> then that memory will be accessed as encrypted memory. The memory encryption
>> mask (as well as other related information) is determined from settings
>> returned through the same CPUID function that identifies the presence of the
>> feature.
>>
>> The approach that this patch series takes is to encrypt everything possible
>> starting early in the boot where the kernel is encrypted. Using the page
>> table macros the encryption mask can be incorporated into all page table
>> entries and page allocations. By updating the protection map, userspace
>> allocations are also marked encrypted. Certain data must be accounted for
>> as having been placed in memory before SME was enabled (EFI, initrd, etc.)
>> and accessed accordingly.
>>
>> This patch series is a pre-cursor to another AMD processor feature called
>> Secure Encrypted Virtualization (SEV). The support for SEV will build upon
>> the SME support and will be submitted later. Details on SEV can be found
>> in the links below.
> 
> Well done series. Thanks to all people involved, especially Tom and Boris!
> It was a pleasure to review that.
> 
> Reviewed-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

A big thanks from me to everyone that helped review this.  I truly
appreciate all the time that everyone put into this - especially Boris,
who helped guide this series from the start.

Thanks,
Tom

> 
