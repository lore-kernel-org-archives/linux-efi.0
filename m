From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Mon, 18 Nov 2013 19:02:29 -0800
Message-ID: <CAE9FiQW+kbq5Eu-ivu897ogQUGjwKy6jYO9hnxbKyuWqoaQgJQ@mail.gmail.com>
References: <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
	<20131114180455.GA32212@anatevka.fc.hp.com>
	<CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
	<20131115005049.GJ5116@anatevka.fc.hp.com>
	<20131115062417.GB9237@gmail.com>
	<CAE9FiQWzSTtW8N=0hoUe6iCSM-k64Mv97n0whAS0_vZ+psuOsg@mail.gmail.com>
	<5285C639.5040203@zytor.com>
	<20131115140738.GB6637@redhat.com>
	<CAE9FiQUnw9Ujmdtq-AgC4VctQ=fZSBkzehoTbvw=aZeARL+pwA@mail.gmail.com>
	<52865CA1.5020309@zytor.com>
	<20131115183002.GE6637@redhat.com>
	<528ABFA3.6060905@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <528ABFA3.6060905-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, jerry.hoemann-VXdhtT5mjnY@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 18, 2013 at 5:32 PM, H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> wrote:
> On 11/15/2013 10:30 AM, Vivek Goyal wrote:
>>
>> And IOMMU support is very flaky with kdump. And IOMMU's can be turned
>> off at command line. And that would force one to remove crahkernel_low=0.
>> So change of one command line option forces change of another. It is
>> complicated.
>>
>> Also there are very few systems which work with IOMMU on. A lot more
>> which work without IOMMU. We have all these DMAR issues and still nobody
>> has been able to address IOMMU issues properly.
>>
>
> Why do we need such a big bounce buffer for kdump swiotlb anyway?
> Surely the vast majority of all dump devices don't need it, so it is
> there for completeness, no?

Yes, because normal path will need that 64M+32k default.

We may reduce that amount to 16M or 18M and in second kernel let
allocate less for swiotlb.

Thanks

Yinghai
