From: poma <pomidorabelisima@gmail.com>
Subject: Re: [PATCH 11/24] uswsusp: Disable when the kernel is locked down
Date: Sat, 8 Apr 2017 05:28:15 +0200
Message-ID: <83e2dff5-c46b-25b4-253e-cd2650b7db7d@gmail.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142336965.5101.2946578135980499557.stgit@warthog.procyon.org.uk>
 <CAJZ5v0hp=GJtQ+YnNdaMw6rtbBzNyueY+iqjPkHLKp57t822ZQ@mail.gmail.com>
 <1491460792.1645.1.camel@suse.com> <14980.1491468060@warthog.procyon.org.uk>
 <CAJZ5v0gFeF3hdr0QzUeaT2dS+HhG7KUdVPPWHKeqHVkX78s+Tw@mail.gmail.com>
 <CAJZ5v0jwQPd3HfwE1Yi6bmyULFVegkU4fNvt0uXGvzAdecLEZA@mail.gmail.com>
 <alpine.LSU.2.20.1704062224220.28004@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.20.1704062224220.28004@cbobk.fhfr.pm>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Oliver Neukum <oneukum@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux PM <linux-pm@vger.kernel.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, Joey Lee <JLee@suse.com>, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

On 06.04.2017 22:25, Jiri Kosina wrote:
> On Thu, 6 Apr 2017, Rafael J. Wysocki wrote:
> 
>>>>> Your swap partition may be located on an NVDIMM or be encrypted.
>>>>
>>>> An NVDIMM should be considered the same as any other persistent storage.
>>>>
>>>> It may be encrypted, but where's the key stored, how easy is it to retrieve
>>>> and does the swapout code know this?
>>>>
>>>>> Isn't this a bit overly drastic?
>>>>
>>>> Perhaps, but if it's on disk and it's not encrypted, then maybe not.
>>>
>>> Right.
>>>
>>> Swap encryption is not mandatory and I'm not sure how the hibernate
>>> code can verify whether or not it is in use.
>>
>> BTW, SUSE has patches adding secure boot support to the hibernate code
>> and Jiri promised me to post them last year even. :-)
> 
> Oh, thanks for a friendly ping :) Adding Joey Lee to CC.
> 

Rafael J., are you talking about HIBERNATE_VERIFICATION ?

Ref.
https://github.com/joeyli/linux-s4sign/commits/s4sign-hmac-v2-v4.2-rc8
https://lkml.org/lkml/2015/8/11/47
https://bugzilla.redhat.com/show_bug.cgi?id=1330335
