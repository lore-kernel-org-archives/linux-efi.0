From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 8/8] efi: Add EFI_SECURE_BOOT bit [ver #6]
Date: Wed, 11 Jan 2017 15:29:24 +0000
Message-ID: <7979.1484148564@warthog.procyon.org.uk>
References: <20170111145138.GB29649@codeblueprint.co.uk>
 <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
 <148120026820.5854.13036556358308461345.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170111145138.GB29649@codeblueprint.co.uk>
Content-ID: <7978.1484148564.1@warthog.procyon.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Matt Fleming <matt@codeblueprint.co.uk> wrote:

> Before we add more efi.flags bits I'd like this series to include the
> patch that makes use of EFI_SECURE_BOOT. Alternatively, you move this
> last patch to a new series.

Are you willing to take the kernel lock-down patches also?

David
