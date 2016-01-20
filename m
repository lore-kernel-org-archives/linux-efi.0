From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH v2 08/16] xen/hvm/params: Add a new delivery
 type for event-channel in HVM_PARAM_CALLBACK_IRQ
Date: Wed, 20 Jan 2016 16:45:13 +0800
Message-ID: <569F4919.2040502@huawei.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com> <1452840929-19612-9-git-send-email-zhaoshenglong@huawei.com> <alpine.DEB.2.02.1601181205110.16178@kaball.uk.xensource.com> <569CDDB7.9030103@citrix.com> <alpine.DEB.2.02.1601181244300.16178@kaball.uk.xensource.com> <569CE00C.5050406@citrix.com> <569F2A4D.9070006@huawei.com> <569F47C8.9080005@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569F47C8.9080005-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Cooper <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 2016/1/20 16:39, Andrew Cooper wrote:
> On 20/01/2016 06:33, Shannon Zhao wrote:
>> >
>> > On 2016/1/18 20:52, Andrew Cooper wrote:
>>> >> On 18/01/16 12:46, Stefano Stabellini wrote:
>>>>> >>>> On Mon, 18 Jan 2016, Andrew Cooper wrote:
>>>>>>> >>>>>> On 18/01/16 12:38, Stefano Stabellini wrote:
>>>>>>>>> >>>>>>>> On Fri, 15 Jan 2016, Shannon Zhao wrote:
>>>>>>>>>>> >>>>>>>>>> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>>>>>>>>> >>>>>>>>>>
>>>>>>>>>>> >>>>>>>>>> Add a new delivery type:
>>>>>>>>>>> >>>>>>>>>> val[63:56] == 3: val[15:8] is flag: val[7:0] is a PPI.
>>>>>>>>>>> >>>>>>>>>> To the flag, bit 0 stands the interrupt mode is edge(1) or level(0) and
>>>>>>>>>>> >>>>>>>>>> bit 1 stands the interrupt polarity is active low(1) or high(0).
>>>>>>>>>>> >>>>>>>>>>
>>>>>>>>>>> >>>>>>>>>> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>>>>>>>>> >>>>>>>>>> ---
>>>>>>>>>>> >>>>>>>>>>  include/xen/interface/hvm/params.h | 5 +++++
>>>>>>>>>>> >>>>>>>>>>  1 file changed, 5 insertions(+)
>>>>>>>>>>> >>>>>>>>>>
>>>>>>>>>>> >>>>>>>>>> diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
>>>>>>>>>>> >>>>>>>>>> index a6c7991..550688a 100644
>>>>>>>>>>> >>>>>>>>>> --- a/include/xen/interface/hvm/params.h
>>>>>>>>>>> >>>>>>>>>> +++ b/include/xen/interface/hvm/params.h
>>>>>>>>>>> >>>>>>>>>> @@ -34,6 +34,11 @@
>>>>>>>>>>> >>>>>>>>>>   *                  Domain = val[47:32], Bus  = val[31:16],
>>>>>>>>>>> >>>>>>>>>>   *                  DevFn  = val[15: 8], IntX = val[ 1: 0]
>>>>>>>>>>> >>>>>>>>>>   * val[63:56] == 2: val[7:0] is a vector number.
>>>>>>>>>>> >>>>>>>>>> + * val[63:56] == 3: val[15:8] is flag of event-channel interrupt:
>>>>>>>>>>> >>>>>>>>>> + *                      bit 0: interrupt is edge(1) or level(0) triggered
>>>>>>>>>>> >>>>>>>>>> + *                      bit 1: interrupt is active low(1) or high(0)
>>>>>>>>>>> >>>>>>>>>> + *                  val[7:0] is PPI number used by event-channel.
>>>>>>>>>>> >>>>>>>>>> + *                  This is only used by ARM/ARM64.
>>>>>>>>>>> >>>>>>>>>>   * If val == 0 then CPU0 event-channel notifications are not delivered.
>>>>>>>>>>> >>>>>>>>>>   */
>>>>>>>>>>> >>>>>>>>>>  #define HVM_PARAM_CALLBACK_IRQ 0
>>>>>>>>> >>>>>>>> Andrew, I think that this patch is correct. Looking back at your
>>>>>>>>> >>>>>>>> previous comment (http://marc.info/?l=devicetree&m=144804014214262&w=2),
>>>>>>>>> >>>>>>>> is it possible that you were confused by enum callback_via_type, which
>>>>>>>>> >>>>>>>> is internal to Xen and offset'ed by 1 compared to the described values
>>>>>>>>> >>>>>>>> in xen/include/public/hvm/params.h?
>>>>>>>>> >>>>>>>>
>>>>>>>>> >>>>>>>> If not, and indeed somebody introduced one more field but failed to
>>>>>>>>> >>>>>>>> document it, then I suggest she sends a patch to fix the issue as soon
>>>>>>>>> >>>>>>>> as possible.
>>>>>>> >>>>>> I was indeed confused - the ABI is utterly mad.
>>>>> >>>> All right. In that case, Shannon, you can add my
>>>>> >>>>
>>>>> >>>> Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
>>>>> >>>>
>>>>> >>>>
>>>>>>> >>>>>> However, this change does need rebasing over c/s ca5c54b, which was the
>>>>>>> >>>>>> result of the original discussion.
>>>>> >>>> c/s ca5c54b is for Xen, while this is a Linux patch (Linux has its own
>>>>> >>>> set of Xen headers).
>>> >> All ABI changes need to happen in the Xen public headers first.  This
>>> >> patch cannot be accepted yet.
>> > So you mean it should port c/s ca5c54b to Linux first? Then add this
>> > change based on that?
> FIrst, you must get this content and submit a patch against Xen.  The
> Xen repository is the authoritative version of the ABI.
> 
I've sent a patch to Xen, but not applied yet.

> Once that patch is accepted, you will need to port ca5c54b and the new
> patch as part of this series.
Ok, thanks.

-- 
Shannon
