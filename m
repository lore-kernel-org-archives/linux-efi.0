From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [PATCH v8 0/2] Enable capsule loader interface for efi firmware
 updating
Date: Thu, 08 Oct 2015 12:01:27 +0100
Message-ID: <56164D07.7060007@nexus-software.ie>
References: <1444245233-19229-1-git-send-email-hock.leong.kweh@intel.com> <56153352.8020704@nexus-software.ie> <F54AEECA5E2B9541821D670476DAE19C4A873959@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A873959@PGSMSX102.gar.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Fleming, Matt" <matt.fleming@intel.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

On 08/10/15 04:50, Kweh, Hock Leong wrote:
>> -----Original Message-----
>> From: Bryan O'Donoghue [mailto:pure.logic@nexus-software.ie]
>> Sent: Wednesday, October 07, 2015 11:00 PM
>>
>> Wilson.
>>
>> Same question as at V7. If you aren't supporting the MFH on Galileo then
>> what capsule are you using with 0.75 BIOS ? From memory it won't work
>> without the MFH included ...
>>
>> --
>> BOD
>
> As I mentioned before the Quark Security Header patch will not upstream
> to mainline and will be carried by Intel. So to test with Quark Platform, I will
> apply that patch into my kernel.

Ah OK gotcha.

You're not actually going to provide support for capsule update in 
mainline for Quark then.

I'll take that discussion to a separate thread.

--
BOD


