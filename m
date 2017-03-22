From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH V11 10/10] arm/arm64: KVM: add guest SEA support
Date: Wed, 22 Mar 2017 11:14:21 +0000
Message-ID: <58D25C8D.3070507@arm.com>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org> <1487712121-16688-11-git-send-email-tbaicar@codeaurora.org> <df6ba5dc-d93f-925a-46bf-1e1e209d17f3@huawei.com> <58B43092.6040401@arm.com> <6eee7a67-808e-8712-2ec2-593eac52d921@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6eee7a67-808e-8712-2ec2-593eac52d921-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Xiongfeng Wang <wangxiongfeng2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: xiexiuqi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, gengdongjiu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, punit.agrawal-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, will.deacon-5wv7dgnIgG8@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, rjw@
List-Id: linux-efi@vger.kernel.org

Hi Wang Xiongfeng,

On 22/03/17 02:46, Xiongfeng Wang wrote:
>> Guests are a special case as QEMU may never access the faulty memory itself, so
>> it won't receive the 'late' signal. It looks like ARM/arm64 KVM lacks support
>> for KVM_PFN_ERR_HWPOISON which sends SIGBUS from KVM's fault-handling code. I
>> have patches to add support for this which I intend to send at rc1.
>>
>> [0] suggests 'KVM qemu' sets these MCE flags to take the 'early' path, but given
>> x86s KVM_PFN_ERR_HWPOISON, this may be out of date.
>>
>>
>> Either way, once QEMU gets a signal indicating the virtual address, it can
>> generate its own APEI CPER records and use the KVM APIs to mock up an
>> Synchronous External Abort, (or inject an IRQ or run the vcpu waiting for the
>> guest's polling thread to come round, whichever was described to the guest via
>> the HEST/GHES tables).
>>
> 
> I have another confusion about the SIGBUS signal. Can QEMU always get a SIGBUS when needed.
> I know one circumstance which will send SIGBUS. The ghes_handle_memory_failure() in
> ghes_do_proc() will send SIGBUS to QEMU, but this only happens when there exists memory section
> in ghes, that is the section type is CPER_SEC_PLATFORM_MEM.
> Suppose this case, an load  error in guest application causes an SEA, and the firmware take it.
> The firmware begin to scan the error record and fill the ghes. But the error record in memory node
> has been read by other handler.

(this looks like a race)

> The firmware won't add memory section in ghes, so ghes_handle_memory_failure() won't be called.

I think this would be a firmware bug. Firmware can reserve as much memory as it
needs for writing CPER records, there should not be a case where 'the memory' is
currently being processed by another handler.

The memory firmware uses to write CPER records too shouldn't be published to the
OS until it has finished. Once firmware has finished writing the CPER records it
can update the memory pointed to by GHES->ErrorStatusAddress with the location
of the CPER records and invoke the Notification method for this GHES. (SEI, SEA,
IRQ etc). We should always get a complete set of CPER records to describe the error.

It firmware uses GHESv2 it can get an 'ack' write from APEI once it has finished
processing the records. Once it gets this firmware knows it can re-use the memory.

(Obviously each GHES entry can only process one error at a time. Firmware should
either handle this, or have one entry for each Error Source that can happen
independently)


> I mean that we may not rely on ghes_handle_memory_failure() to send SIGBUS to QEMU. Whether we should
> add some other code to send SIGBUS in handle_guest_abort(). I don't know whether the ARM/arm64
>  KVM_PFN_ERR_HWPOISON you mentioned above will cover all the cases.

The SIGBUS routine is part of the kernel's recovery method for memory errors. It
should cover all the errors reported with this CPER_SEC_PLATFORM_MEM.

Back to the race you describe. It shouldn't matter if one CPU processes an error
for guest memory while a vcpu is running on another. This may happen if the
error was detected by DRAM's background scrub.
If we don't treat KVM/Qemu as anything special the memory_failure()->SIGBUS path
will happen regardless of whether the fault interrupted the guest or not.


There are other types of error such as PCIe, CPU, BUS error etc. If it's
possible to recover from these we may need additional code in the kernel. This
shouldn't necessarily treat KVM as a special case.


Thanks,

James
