import subprocess
import json
from datetime import datetime

print("=" * 60)
print("       CI/CD PIPELINE DEMONSTRATION")
print("=" * 60)
print()


class Pipeline:
    """Simple CI/CD Pipeline"""
    
    def __init__(self, name):
        self.name = name
        self.stages = []
        self.results = []
    
    def add_stage(self, name, commands):
        """Add a stage to the pipeline"""
        self.stages.append({"name": name, "commands": commands})
    
    def run_stage(self, stage):
        """Execute a pipeline stage"""
        stage_name = stage["name"]
        print(f"\n{'='*40}")
        print(f"Stage: {stage_name}")
        print('='*40)
        
        start_time = datetime.now()
        success = True
        outputs = []
        
        for cmd in stage["commands"]:
            print(f"  Running: {cmd}")
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            
            if result.returncode != 0:
                print(f"  ✗ Failed: {result.stderr}")
                success = False
                break
            else:
                print(f"  ✓ Success")
                outputs.append(result.stdout.strip())
        
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        
        result = {
            "stage": stage_name,
            "success": success,
            "duration": duration,
            "outputs": outputs
        }
        
        self.results.append(result)
        return success
    
    def run(self):
        """Execute the entire pipeline"""
        print(f"\n🚀 Starting Pipeline: {self.name}")
        
        for stage in self.stages:
            if not self.run_stage(stage):
                print(f"\n❌ Pipeline failed at stage: {stage['name']}")
                return False
        
        print(f"\n✅ Pipeline completed successfully!")
        return True
    
    def get_summary(self):
        """Get pipeline summary"""
        total_duration = sum(r["duration"] for r in self.results)
        return {
            "pipeline": self.name,
            "total_stages": len(self.stages),
            "completed_stages": len(self.results),
            "total_duration": f"{total_duration:.2f}s",
            "status": "success" if all(r["success"] for r in self.results) else "failed"
        }


def main():
    # Create pipeline
    pipeline = Pipeline("Build and Deploy")
    
    # Add stages
    pipeline.add_stage("Checkout", [
        "echo 'Checking out code...'",
        "echo 'Repository: https://github.com/example/app'"
    ])
    
    pipeline.add_stage("Build", [
        "echo 'Building application...'",
        "echo 'Compiling source files...'",
        "echo 'Build artifacts created'"
    ])
    
    pipeline.add_stage("Test", [
        "echo 'Running unit tests...'",
        "echo 'Running integration tests...'",
        "echo 'All tests passed'"
    ])
    
    pipeline.add_stage("Deploy", [
        "echo 'Deploying to production...'",
        "echo 'Deployment successful'"
    ])
    
    # Run pipeline
    pipeline.run()
    
    # Print summary
    print("\n" + "="*40)
    print("Pipeline Summary")
    print("="*40)
    summary = pipeline.get_summary()
    for key, value in summary.items():
        print(f"  {key}: {value}")


if __name__ == "__main__":
    main()
    print("\n" + "=" * 60)
    print("           DEMO COMPLETE")
    print("=" * 60)
