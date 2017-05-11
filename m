From: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] efi/cper: Fix endianness of PCI class code
Date: Thu, 11 May 2017 07:48:52 -0700
Message-ID: <2d5f9331-6f31-2584-9ec1-2447163c6611@caviumnetworks.com>
References: <771bc335fb5856792d086ae7db288dcf244cb4cd.1493964354.git.lukas@wunner.de>
 <CAKv+Gu9PpmTBbSMKUsx6svm6fodV8x=i4b1j8QGapnEoCFcrNA@mail.gmail.com>
 <20170506090755.GB19740@wunner.de>
 <CAKv+Gu_4xHhX8oK847k8=s5S7Mx3sALPTtX8Eo=2+9uZyQoEAQ@mail.gmail.com>
 <20170510084143.GA16261@wunner.de>
 <CAKv+Gu81gvNL1jkb3T35=-5fr_x-BmSg9X2CcQ97xv5JTZ-c1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu81gvNL1jkb3T35=-5fr_x-BmSg9X2CcQ97xv5JTZ-c1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 05/11/2017 07:06 AM, Ard Biesheuvel wrote:
> On 10 May 2017 at 09:41, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
>> On Wed, May 10, 2017 at 09:03:11AM +0100, Ard Biesheuvel wrote:
[...]
>>
>> It seems clumsy and unnecessary to me so I'd prefer the bitfield.
>> Please excuse my stubbornness.
>>
> 
> Stubbornness alone is not going to convince me. What *could* convince
> me (although unlikely) is a quote from the C spec which explains why
> it is 100% legal to make assumptions about how bitfields are projected
> onto byte locations in memory.

I don't think you will find that in the C specifications.

Structure layout is specified per-architecture/per-ABI so for the Linux 
kernel you would only have to check that it is strongly specified and 
compatible across `ls arch | wc -l` different architectures.  If you 
want to get started with MIPS, for example, you could look in the 
"SYSTEM V APPLICATION BINARY INTERFACE MIPS(r) RISC Processor Supplement 
3rd Edition" starting on page 3-7.  For x86 and arm{,64} I am sure you 
could find similar specifications.

David Daney
