From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v9 00/38] x86: Secure Memory Encryption (AMD)
Date: Mon, 10 Jul 2017 13:04:11 -0500
Message-ID: <fce185d2-4420-7255-6331-6231c643c8c7@amd.com>
References: <20170707133804.29711.1616.stgit@tlendack-t1.amdoffice.net>
 <20170708092426.prf7xmmnv6xvdqx4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170708092426.prf7xmmnv6xvdqx4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 7/8/2017 4:24 AM, Ingo Molnar wrote:
> 
> * Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org> wrote:
> 
>> This patch series provides support for AMD's new Secure Memory Encryption (SME)
>> feature.
> 
> I'm wondering, what's the typical performance hit to DRAM access latency when SME
> is enabled?

It's about an extra 10 cycles of DRAM latency when performing an
encryption or decryption operation.

> 
> On that same note, if the performance hit is noticeable I'd expect SME to not be
> enabled in native kernels typically - but still it looks like a useful hardware

In some internal testing we've seen about 1.5% or less reduction in
performance. Of course it all depends on the workload: the number of
memory accesses, cache friendliness, etc.

> feature. Since it's controlled at the page table level, have you considered
> allowing SME-activated vmas via mmap(), even on kernels that are otherwise not
> using encrypted DRAM?

That is definitely something to consider as an additional SME-related
feature and something I can look into after this.

Thanks,
Tom

> 
> One would think that putting encryption keys into such encrypted RAM regions would
> generally improve robustness against various physical space attacks that want to
> extract keys but don't have full control of the CPU.
> 
> Thanks,
> 
> 	Ingo
> 
