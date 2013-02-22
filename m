From: John Stultz <john.stultz@linaro.org>
Subject: Re: [RFE PATCH 2/2] rtc, add write functionality to sysfs
Date: Fri, 22 Feb 2013 13:05:51 -0800
Message-ID: <5127DDAF.2000403@linaro.org>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-3-git-send-email-prarit@redhat.com> <5127D884.6020701@linaro.org> <5127DB2B.3030700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5127DB2B.3030700@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Matt Fleming <matt.fleming@intel.com>, David Vrabel <david.vrabel@citrix.com>, Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>, linux-efi@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>
List-Id: linux-efi@vger.kernel.org

On 02/22/2013 12:55 PM, Prarit Bhargava wrote:
>
> On 02/22/2013 03:43 PM, John Stultz wrote:
>> On 02/14/2013 09:02 AM, Prarit Bhargava wrote:
>>> /sys/class/rtc/rtcX/date and /sys/class/rtc/rtcX/time currently have
>>> read-only access.  This patch introduces write functionality which will
>>> set the rtc time.
>>>
>>> Usage: echo YYYY-MM-DD > /sys/class/rtc/rtcX/date
>>>          echo HH:MM:SS > /sys/class/rtc/rtcX/time
>> Why do we want to add a new interface here?
> John,
>
> I'm not adding a new interface.  The current date/time interface only handles
> read and I'm introducing write.
>

Right, but what benefit does that provide?
(I'm not saying there isn't any, its just not clear from your patch why 
this is a good thing.)

Also CC'ing Alessandro for his input.

thanks
-john
