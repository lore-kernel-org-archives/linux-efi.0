From: Zachary Bobroff <zacharyb@ami.com>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Date: Tue, 18 Jun 2013 04:20:01 +0000
Message-ID: <B0277B82-F2C5-4BA9-B42C-F554E12F6961@ami.com>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
	 <1371139233.6523.272.camel@linux-s257.site>
	 <20130617092107.GA5440@console-pimps.org>
	 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
	 <20130617101745.GB8569@console-pimps.org>
	 <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
	 <20130617123052.GE8569@console-pimps.org>
	 <7BD74F8E52BFD147B6C83AE7A1E893FFE285F690@atlms1.us.megatrends.com>,<1371523665.6523.336.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1371523665.6523.336.camel@linux-s257.site>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: Matt Fleming <matt@console-pimps.org>, Jan Beulich <JBeulich@suse.com>, Matt Fleming <matt.fleming@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

The timer is shutdown before callbacks on exitbootservices are called.  The bios should be entirely single threaded at this point unless Linux has started some other CPUs.  So exitbootservices will not return until each until each callback is complete.  In short, then it would return the status of failure if the memory map has changed, success otherwise.  The callbacks are not called on any subsequent call to exitbootservices, so the map should stay the same then.

Sent from my iPhone

On Jun 17, 2013, at 10:48 PM, "joeyli" <jlee@suse.com> wrote:

> Hi Zach, 
> 
> 於 二，2013-06-18 於 00:18 +0000，Zachary Bobroff 提到：
>> All,
>> 
>>>> Why a single retry is having reasonable guarantees to work when the
>> original one failed (nothing prevents an event handler to do another
>> allocation the next time through).
>> 
>> This patch is being submitted because of the potential issues that
>> occur when 3rd party option ROMs are signaled by the ExitBootServices
>> event. At the time they are signaled, they can perform any number of
>> actions that would change the EFI Memory map.  This wasn't actually
>> seen with our default implementation of our firmware, it was seen when
>> this plug-in card's option rom was run.
>> 
>> We only need to retry once because of what is in the UEFI
>> specification 2.3.1 Errata C.  The exact verbiage is as follows:
>> 
>> The ExitBootServices() function is called by the currently executing
>> EFI OS loader image to terminate all boot services. On success, the
>> loader becomes responsible for the continued operation of the system.
>> All events of type EVT_SIGNAL_EXIT_BOOT_SERVICES must be signaled
>> before ExitBootServices() returns EFI_SUCCESS. The events are only
>> signaled once even if ExitBootServices() is called multiple times.
>> 
>> Since the firmware will only signal the ExitBootServices event once,
>> the code that has the potential to change the memory map will only be
>> signaled on the first call to exit boot services. 
> 
> Does it possible have any delay time of 3rd party ROMs to change EFI
> memory map after they are signaled?
> or ExitBootServices() will wait all 3rd party ROMs updated memory map
> finished then return true/false to kernel?
> 
> 
> Thanks a lot!
> Joey Lee
> 

The information contained in this message may be confidential and proprietary to American Megatrends, Inc.  This communication is intended to be read only by the individual or entity to whom it is addressed or by their designee. If the reader of this message is not the intended recipient, you are on notice that any distribution of this message, in any form, is strictly prohibited.  Please promptly notify the sender by reply e-mail or by telephone at 770-246-8600, and then delete or destroy all copies of the transmission.
