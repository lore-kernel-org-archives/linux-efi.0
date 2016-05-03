From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/18] x86: Secure Memory Encryption (AMD)
Date: Tue, 3 May 2016 10:55:13 -0500
Message-ID: <5728C9E1.3050803@amd.com>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
	<94D0CD8314A33A4D9D801C0FE68B402963918FDA@G4W3296.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402963918FDA-wwDBVnaDRpYSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>, "linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/30/2016 01:13 AM, Elliott, Robert (Persistent Memory) wrote:
>> -----Original Message-----
>> From: linux-kernel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-kernel-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Tom Lendacky
>> Sent: Tuesday, April 26, 2016 5:56 PM
>> Subject: [RFC PATCH v1 00/18] x86: Secure Memory Encryption (AMD)
>>
>> This RFC patch series provides support for AMD's new Secure Memory
>> Encryption (SME) feature.
>>
>> SME can be used to mark individual pages of memory as encrypted through the
>> page tables. A page of memory that is marked encrypted will be automatically
>> decrypted when read from DRAM and will be automatically encrypted when
>> written to DRAM. Details on SME can found in the links below.
>>
> ...
>> ...  Certain data must be accounted for
>> as having been placed in memory before SME was enabled (EFI, initrd, etc.)
>> and accessed accordingly.
>>
> ...
>>       x86/efi: Access EFI related tables in the clear
>>       x86: Access device tree in the clear
>>       x86: Do not specify encrypted memory for VGA mapping
> 
> If the SME encryption key "is created randomly each time a system is booted,"
> data on NVDIMMs won't decrypt properly on the next boot.  You need to exclude
> persistent memory regions (reported in the UEFI memory map as 
> EfiReservedMemoryType with the NV attribute, or as EfiPersistentMemory).

The current plan is for the AMD Secure Processor to securely save the
SME encryption key when NVDIMMs are installed on a system. The saved SME
key will be restored if an NVDIMM restore event needs to be performed.
If there isn't an NVDIMM restore event, then the randomly generated key
will be used.

Thanks,
Tom

> 
> Perhaps the SEV feature will allow key export/import that could work for
> NVDIMMs.
> 
> ---
> Robert Elliott, HPE Persistent Memory
> 
> 
