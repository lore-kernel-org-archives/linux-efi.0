From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] efi: Get the secure boot status [ver #3]
Date: Fri, 25 Nov 2016 09:30:20 +0000
Message-ID: <15173.1480066220@warthog.procyon.org.uk>
References: <1480016487.2444.18.camel@HansenPartnership.com>
 <147990561294.7576.6464430479448167484.stgit@warthog.procyon.org.uk>
 <147990565051.7576.9673287945782426886.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1480016487.2444.18.camel@HansenPartnership.com>
Content-ID: <15172.1480066220.1@warthog.procyon.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, lukas@wunner.de, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Since you seem to be using this to mean "is the platform locked down?",
> this looks to be no longer complete in the UEFI 2.6 world.  If
> DeployedMode == 0, even if SecureBoot == 1 and SetupMode == 0, you can
> remove the platform key by writing 1 to AuditMode and gain control of
> the secure variables.  The lock down state becomes DeployedMode == 1,
> SecureBoot == 1 and SetupMode == 0
> 
> See the diagram on page 1817
> 
> http://www.uefi.org/sites/default/files/resources/UEFI%20Spec%202_6.pdf

How many pages?!

Does the DeployedMode variable not exist in older versions of the UEFI spec?

David
