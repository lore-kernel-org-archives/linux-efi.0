From: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: compatability with older versions of UEFI
Date: Wed, 24 Jun 2015 16:50:09 -0700
Message-ID: <558B4231.7020907@codeaurora.org>
References: <20150623170534.GA21341@agluck-desk.sc.intel.com> <558AF115.8020909@codeaurora.org> <3908561D78D1C84285E8C5FCA982C28F32A9FB7C@ORSMSX114.amr.corp.intel.com> <558B09F8.4060706@codeaurora.org> <3908561D78D1C84285E8C5FCA982C28F32A9FBFF@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32A9FBFF-8oqHQFITsIE64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mchehab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org" <linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, "harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linaro-acpi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <linaro-acpi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

+Mauro

On 6/24/2015 1:12 PM, Luck, Tony wrote:
>> "Memory Error Section 2". One option we have without having to disturb
>> user space handler of memory error trace data would be to change
>> "struct cper_mem_err_compact" so the affected elements are of
>> __u32 instead of __u16. Drawback of this option is that the trace
>> buffer will be unnecessarily bigger if a platform generates
>> "Memory Error Section" data instead of "Memory Error Section 2" data.
>
> That structure is visible to user level consumers of the event (perhaps just
> one of those right now?):
>
>    git://git.fedorahosted.org/rasdaemon.git
>
> We were not as smart as UEFI and didn't include a version number, or other
> plan,  that would allow us to transition to a new format cleanly.
>
> Perhaps we could re-purpose some of the high order "validation_bits"
> as a version number?  It's a u64 and UEFI 2.5 is only up to bit21 so far,
> so perhaps it will be a long, long time before they get that many fields
> in some future standard.
I agree that we could re-purpose some of the high order "validation_bits"
as a version number. That being said, I am not sure whether that
approach is preferred by user space tool authors. My feeling is
such approach would make user space tool more complicated (eg.
has to understand versions). Mauro, pls. correct me is I am wrong;
pls. refer to previous email in this thread for context related to
challenge brought forth by UEFI 2.5.

perf interface has debugfs interface, so if user space tool does
following, compatibility with different kernel version and different
spec version will be maintained:
* Use debugfs interface to discover format of trace data.
* use largest size known for user space structure; check size of member
in user space structure and size of corresponding field in trace data,
adjust data as necessary.

In the mean time, I think when kernel defines TRACE_EVENT, it should
try not having to use __field_struct, that would make format inside that
field opaque to user space tool. For instance:
   __field_struct(struct cper_mem_err_compact, data)
Because of above, ras-extlog-handler.c in rasdaemon has to hardcode
this structure, making it harder to maintain forward/backward
compatibility.

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
