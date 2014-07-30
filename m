From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Wed, 30 Jul 2014 10:10:24 -0700
Message-ID: <53D92700.3040803@infradead.org>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <20140730144803.GB15082@console-pimps.org> <53D909C3.9050205@canonical.com> <53D9259F.5050307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53D9259F.5050307@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>, Matt Fleming <matt@console-pimps.org>
Cc: Colin Ian King <colin.king@canonical.com>, Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, lszubowi@redhat.com, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 07/30/14 10:04, Prarit Bhargava wrote:
> 
> 
> On 07/30/2014 11:05 AM, Colin Ian King wrote:
>> On 30/07/14 15:48, Matt Fleming wrote:
>>> On Wed, 30 Jul, at 12:29:32AM, Borislav Petkov wrote:
>>>> On Tue, Jul 29, 2014 at 01:09:21PM -0400, Prarit Bhargava wrote:
>>>>> The current debug print in EFI does
>>>>>
>>>>> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (0MB)
>>>>>
>>>>> and rounds off the size to 0MB and isn't very useful.  We should print this in
>>>>> Kib.  After applying this patch we get better info with
>>>>>
>>>>> [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x00000000645b5000-0x00000000645fb000) (280kiB)
>>>>
>>>> Turning this into kiB unconditionally won't always work ok:
>>>>
>>>> First of all, there might be something which parses that output so I'd
>>>> make sure I'm not breaking that. Maybe fwts... Matt will know.
>>>
>>> I'm not aware of anything that parses the dmesg output, but I'm
>>> including Colin in case he has any insight.
>>>
>> That won't break fwts.
> 
> Matt -- could you make a decision on whether or not this should be strictly in
> KiB or if it should be a rolling KiB, Mib, and GiB?
> 
> My issue is simply that I'd like to know *exactly* how big each range is and not
> have it rounded off.  Others think that it is easier to read Mib & Gib ...

It is easier to read in MiB or GiB IMHO, but since it is debug info,
exact is good.  It would be even better [more readable] to use commas
(or periods/dots) to separate it into groups of 3 digits.


-- 
~Randy
