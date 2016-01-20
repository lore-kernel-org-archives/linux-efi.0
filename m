From: Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v2 08/16] xen/hvm/params: Add a new delivery
 type for event-channel in HVM_PARAM_CALLBACK_IRQ
Date: Wed, 20 Jan 2016 08:39:36 +0000
Message-ID: <569F47C8.9080005@citrix.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
	<1452840929-19612-9-git-send-email-zhaoshenglong@huawei.com>
	<alpine.DEB.2.02.1601181205110.16178@kaball.uk.xensource.com>
	<569CDDB7.9030103@citrix.com>
	<alpine.DEB.2.02.1601181244300.16178@kaball.uk.xensource.com>
	<569CE00C.5050406@citrix.com> <569F2A4D.9070006@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <569F2A4D.9070006@huawei.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@citrix.com, stefano.stabellini@citrix.com, david.vrabel@citrix.com, peter.huangpeng@huawei.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: linux-efi@vger.kernel.org

On 20/01/2016 06:33, Shannon Zhao wrote:
>
> On 2016/1/18 20:52, Andrew Cooper wrote:
>> On 18/01/16 12:46, Stefano Stabellini wrote:
>>>> On Mon, 18 Jan 2016, Andrew Cooper wrote:
>>>>>> On 18/01/16 12:38, Stefano Stabellini wrote:
>>>>>>>> On Fri, 15 Jan 2016, Shannon Zhao wrote:
>>>>>>>>>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>>>>>>>>
>>>>>>>>>> Add a new delivery type:
>>>>>>>>>> val[63:56] == 3: val[15:8] is flag: val[7:0] is a PPI.
>>>>>>>>>> To the flag, bit 0 stands the interrupt mode is edge(1) or level(0) and
>>>>>>>>>> bit 1 stands the interrupt polarity is active low(1) or high(0).
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>>>>>>>>> ---
>>>>>>>>>>  include/xen/interface/hvm/params.h | 5 +++++
>>>>>>>>>>  1 file changed, 5 insertions(+)
>>>>>>>>>>
>>>>>>>>>> diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
>>>>>>>>>> index a6c7991..550688a 100644
>>>>>>>>>> --- a/include/xen/interface/hvm/params.h
>>>>>>>>>> +++ b/include/xen/interface/hvm/params.h
>>>>>>>>>> @@ -34,6 +34,11 @@
>>>>>>>>>>   *                  Domain = val[47:32], Bus  = val[31:16],
>>>>>>>>>>   *                  DevFn  = val[15: 8], IntX = val[ 1: 0]
>>>>>>>>>>   * val[63:56] == 2: val[7:0] is a vector number.
>>>>>>>>>> + * val[63:56] == 3: val[15:8] is flag of event-channel interrupt:
>>>>>>>>>> + *                      bit 0: interrupt is edge(1) or level(0) triggered
>>>>>>>>>> + *                      bit 1: interrupt is active low(1) or high(0)
>>>>>>>>>> + *                  val[7:0] is PPI number used by event-channel.
>>>>>>>>>> + *                  This is only used by ARM/ARM64.
>>>>>>>>>>   * If val == 0 then CPU0 event-channel notifications are not delivered.
>>>>>>>>>>   */
>>>>>>>>>>  #define HVM_PARAM_CALLBACK_IRQ 0
>>>>>>>> Andrew, I think that this patch is correct. Looking back at your
>>>>>>>> previous comment (http://marc.info/?l=devicetree&m=144804014214262&w=2),
>>>>>>>> is it possible that you were confused by enum callback_via_type, which
>>>>>>>> is internal to Xen and offset'ed by 1 compared to the described values
>>>>>>>> in xen/include/public/hvm/params.h?
>>>>>>>>
>>>>>>>> If not, and indeed somebody introduced one more field but failed to
>>>>>>>> document it, then I suggest she sends a patch to fix the issue as soon
>>>>>>>> as possible.
>>>>>> I was indeed confused - the ABI is utterly mad.
>>>> All right. In that case, Shannon, you can add my
>>>>
>>>> Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>>>
>>>>
>>>>>> However, this change does need rebasing over c/s ca5c54b, which was the
>>>>>> result of the original discussion.
>>>> c/s ca5c54b is for Xen, while this is a Linux patch (Linux has its own
>>>> set of Xen headers).
>> All ABI changes need to happen in the Xen public headers first.  This
>> patch cannot be accepted yet.
> So you mean it should port c/s ca5c54b to Linux first? Then add this
> change based on that?

FIrst, you must get this content and submit a patch against Xen.  The
Xen repository is the authoritative version of the ABI.

Once that patch is accepted, you will need to port ca5c54b and the new
patch as part of this series.

~Andrew
