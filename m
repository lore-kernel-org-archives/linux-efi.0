From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH v3 06/10] arm64: efi: add EFI stub
Date: Wed, 8 Feb 2017 10:35:02 -0600
Message-ID: <73a460e5-98f5-86c2-142f-a9a084ee0203@codeaurora.org>
References: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
 <1396637113-22790-7-git-send-email-leif.lindholm@linaro.org>
 <CAOZdJXWU1dmFfCc88RMp3SvouU7roDiJsA=3aHzwijwhMH7naA@mail.gmail.com>
 <E4BDBC23-A96A-4D84-B7EE-B7967D4E4DDD@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <E4BDBC23-A96A-4D84-B7EE-B7967D4E4DDD@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, lkml <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 02/08/2017 10:29 AM, Ard Biesheuvel wrote:
>>> >> +       status = handle_cmdline_files(sys_table, image, cmdline_ptr,
>>> >> +                                     "initrd=", dram_base + SZ_512M,
>>> >> +                                     (unsigned long *)&initrd_addr,
>>> >> +                                     (unsigned long *)&initrd_size);
>> >
>> > So I know this patch is almost three years old, but why is there a
>> > 512M limit on the initrd size?
>> >
> How do you reckon this constitutes a limit?

handle_cmdline_files() calls efi_high_alloc() with that limit.  I'm still 
trying to understand all the details myself, but apparently our firmware and 
initrd need to fit within the first 512MB because of dram_base + SZ_512M. 
When we change "dram_base + SZ_512M" to "~0", everything works.

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc.  Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
