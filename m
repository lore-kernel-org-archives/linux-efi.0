From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH v1 21/28] KVM: introduce KVM_SEV_ISSUE_CMD ioctl
Date: Mon, 17 Oct 2016 12:57:00 -0500
Message-ID: <59369ed7-9d35-baad-e0a9-ce4a62bc30bb@amd.com>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190849706.9523.17127624683768628621.stgit@brijesh-build-machine>
 <6a6e6a1a-eec8-c547-553d-7746d65fc182@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <6a6e6a1a-eec8-c547-553d-7746d65fc182@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Paolo Bonzini <pbonzini@redhat.com>, simon.guinot@sequanux.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, linus.walleij@linaro.org, linux-mm@kvack.org, paul.gortmaker@windriver.com, hpa@zytor.com, dan.j.williams@intel.com, aarcange@redhat.com, sfr@canb.auug.org.au, andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au, bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org, mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com, bp@suse.de, dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de, keescook@chromium.org, toshi.kani@hpe.com, mathieu.desnoyers@efficios.com, devel@linuxdriverproject.org, tglx@linutronix.de, mchehab@kernel.or
Cc: brijesh.singh@amd.com
List-Id: linux-efi@vger.kernel.org

Hi Paolo,


On 10/13/2016 05:45 AM, Paolo Bonzini wrote:
>
>
> On 23/08/2016 01:28, Brijesh Singh wrote:
>> The ioctl will be used by qemu to issue the Secure Encrypted
>> Virtualization (SEV) guest commands to transition a guest into
>> into SEV-enabled mode.
>>
>> a typical usage:
>>
>> struct kvm_sev_launch_start start;
>> struct kvm_sev_issue_cmd data;
>>
>> data.cmd = KVM_SEV_LAUNCH_START;
>> data.opaque = &start;
>>
>> ret = ioctl(fd, KVM_SEV_ISSUE_CMD, &data);
>>
>> On SEV command failure, data.ret_code will contain the firmware error code.
>
> Please modify the ioctl to require the file descriptor for the PSP.  A
> program without access to /dev/psp should not be able to use SEV.
>

I am not sure if I fully understand this feedback. Let me summaries what 
we have right now.

At highest level SEV key management commands are divided into two sections:

- platform  management : commands used during platform provisioning. PSP 
drv provides ioctl's for these commands. Qemu will not use these 
ioctl's, i believe these ioctl will be used by other tools.

- guest management: command used during guest life cycle. PSP drv 
exports various function and KVM drv calls these function when it 
receives the SEV_ISSUE_CMD ioctl from qemu.

If I understanding correctly then you are recommending that instead of 
exporting various functions from PSP drv we should expose one function 
for the all the guest command handling (something like this).

int psp_issue_cmd_external_user(struct file *filep,
			    	int cmd, unsigned long addr,
			    	int *psp_ret)
{
	/* here we check to ensure that file->f_ops is a valid
	 * psp instance.
          */
	if (filep->f_ops != &psp_fops)
		return -EINVAL;

	/* handle the command */
	return psp_issue_cmd (cmd, addr, timeout, psp_ret);
}

In KVM driver use something like this to invoke the PSP command handler.

int kvm_sev_psp_cmd (struct kvm_sev_issue_cmd *input,
		     unsigned long data)
{
	int ret;
	struct fd f;

	f = fdget(input->psp_fd);
	if (!f.file)
		return -EBADF;
	....

	psp_issue_cmd_external_user(f.file, input->cmd,
				    data, &input->psp_ret);
	....
}

Please let me know if I understood this correctly.

>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |    3 +
>>  arch/x86/kvm/x86.c              |   13 ++++
>>  include/uapi/linux/kvm.h        |  125 +++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 141 insertions(+)
>>
