From: Graeme Gregory <graeme-/SyDAi3Rz4f10XsdtD+oqA@public.gmane.org>
Subject: Re: [PATCH v15 0/6] arm64, numa: Add numa support for arm64 platforms
Date: Tue, 5 Apr 2016 14:08:56 +0100
Message-ID: <5703B8E8.3080408@xora.org.uk>
References: <1457481587-8976-1-git-send-email-ddaney.cavm@gmail.com>
 <56F1936E.1090407@redhat.com> <56F1BD15.4000701@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56F1BD15.4000701-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <public-ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Jon Masters <public-jcm-H+wXaHxf7aLQT0dZR+AlfA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>
Cc: Will Deacon <public-will.deacon-5wv7dgnIgG8-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, public-linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r-wOFGN7rlS/M9smdsby/KFg@public.gmane.org, Rob Herring <public-robh+dt-DgEjT+Ai2ygdnm+yROfE0A-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Frank Rowand <public-frowand.list-Re5JQEeQqe8AvxtiuMwx3w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Grant Likely <public-grant.likely-QSEj5FYQhm4dnm+yROfE0A-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Pawel Moll <public-pawel.moll-5wv7dgnIgG8-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Ian Campbell <public-ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Kumar Gala <public-galak-sgV2jX0FEOL9JmXXK+q4OQ-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Ganapatrao Kulkarni <public-gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Robert Richter <public-rrichter-YGCgFSpz5w/QT0dZR+AlfA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Ard Biesheuvel <public-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Matt Fleming <public-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io-wOFGN7rlS/OO27LBFnlIag@public.gmane.org>
List-Id: linux-efi@vger.kernel.org




On 22/03/16 21:45, David Daney wrote:
> On 03/22/2016 11:48 AM, Jon Masters wrote:
>> On 03/08/2016 06:59 PM, David Daney wrote:
>>
>>> From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
>>>
>>> v15:
>>>
>>>     - Make the distance-map node optional (again), if it is not in
>>>            the device tree, default values are used.
>>>
>>>     - Minor cleanups to of_numa.c as suggested by Rob Harring.
>>
>> Hi David, all,
>>
>> Wondering what the status of this patch series is currently?
>
> I haven't seen any feedback on v15.  My assumption was that the relevant
> arm64 maintainers would take some sort of action after the merge window
> quiets down.
>
> In any event, I am happy to make any improvements that may be suggested.
>
Post merge window series does not apply to 4.6-rc2 or next.

Patch 4 collides in arch/arm64/mm/mmu.c

Thanks

Graeme
